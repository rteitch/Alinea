// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../translation/data/providers/libretranslate_provider.dart';
import '../../translation/data/providers/byok_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _serverController = TextEditingController(text: 'http://localhost:8000/v1');
  final TextEditingController _byokKeyController = TextEditingController();
  final TextEditingController _byokEndpointController = TextEditingController(text: 'https://api-free.deepl.com/v2/translate');

  @override
  void dispose() {
    _serverController.dispose();
    _byokKeyController.dispose();
    _byokEndpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeProvider = ref.watch(activeTranslationProvider);
    final targetLang = ref.watch(targetLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Transparansi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FOSS Commitment Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_open_rounded, color: Colors.green.shade800, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Gratis & 100% FOSS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Alinea dibangun di atas mesin Argos Translate (MIT) & LibreTranslate (AGPL-3.0). Tanpa biaya per karakter (Rp 0 marginal cost), tanpa pelacakan data, dan 100% dapat diaudit sumbernya.',
                        style: TextStyle(fontSize: 12, color: Colors.green.shade900, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 1: Translation Provider
          const Text('Mesin Terjemahan (Translation Engine)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          RadioListTile<String>(
            value: 'libretranslate',
            groupValue: activeProvider.id.startsWith('byok') ? 'byok' : 'libretranslate',
            title: const Row(
              children: [
                Text('LibreTranslate Self-Hosted'),
                SizedBox(width: 8),
                Chip(
                  label: Text('DEFAULT FOSS', style: TextStyle(fontSize: 10, color: Colors.green)),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            subtitle: const Text('Mesin Argos Translate sumber terbuka di server VPS mandiri.'),
            onChanged: (_) {
              ref.read(activeTranslationProvider.notifier).state = LibreTranslateProvider(
                baseUrl: _serverController.text.trim(),
              );
            },
          ),
          RadioListTile<String>(
            value: 'byok',
            groupValue: activeProvider.id.startsWith('byok') ? 'byok' : 'libretranslate',
            title: const Text('Bring Your Own Key (BYOK)'),
            subtitle: const Text('Gunakan API key vendor pihak ketiga milik Anda sendiri (DeepL / Cloud MT).'),
            onChanged: (_) {
              ref.read(activeTranslationProvider.notifier).state = BringYourOwnKeyProvider(
                providerType: 'deepl',
                apiKey: _byokKeyController.text.trim(),
                customEndpoint: _byokEndpointController.text.trim(),
              );
            },
          ),
          const Divider(height: 32),

          // Section 2: Server Gateway URL
          const Text('Alamat Translation Gateway', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: _serverController,
            decoration: const InputDecoration(
              labelText: 'Gateway Base URL',
              hintText: 'http://localhost:8000/v1 atau https://gateway.domain.com/v1',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (val) {
              if (activeProvider.id == 'libretranslate') {
                ref.read(activeTranslationProvider.notifier).state = LibreTranslateProvider(
                  baseUrl: val.trim(),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Section 3: Target Language
          const Text('Bahasa Target Default', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: targetLang,
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            items: const [
              DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia (id)')),
              DropdownMenuItem(value: 'en', child: Text('English (en)')),
              DropdownMenuItem(value: 'ja', child: Text('Japanese (ja)')),
              DropdownMenuItem(value: 'zh', child: Text('Chinese (zh)')),
              DropdownMenuItem(value: 'de', child: Text('German (de)')),
              DropdownMenuItem(value: 'fr', child: Text('French (fr)')),
              DropdownMenuItem(value: 'es', child: Text('Spanish (es)')),
              DropdownMenuItem(value: 'ar', child: Text('Arabic (ar)')),
            ],
            onChanged: (val) {
              if (val != null) {
                ref.read(targetLanguageProvider.notifier).state = val;
              }
            },
          ),
          const Divider(height: 32),

          // Section 4: Local Cache Management
          const Text('Penyimpanan Cache Lokal (Drift SQLite)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Eviksi Cache Otomatis'),
            subtitle: const Text('Menggunakan algoritma LRU untuk menjaga ukuran database tetap ringan.'),
            trailing: OutlinedButton(
              onPressed: () async {
                final cacheRepo = ref.read(translationCacheRepositoryProvider);
                final deleted = await cacheRepo.evictOldestEntries(maxEntries: 0, evictCount: 10000);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$deleted entri cache translasi telah dibersihkan.')),
                  );
                }
              },
              child: const Text('Bersihkan Cache'),
            ),
          ),
          const Divider(height: 32),

          // About Alinea
          Center(
            child: Column(
              children: [
                Text(
                  'Alinea EPUB Reader v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Read first, translate seamlessly when needed.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
