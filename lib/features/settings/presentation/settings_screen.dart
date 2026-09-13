// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../glossary/presentation/glossary_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _serverController;
  late TextEditingController _byokKeyController;
  late TextEditingController _byokEndpointController;

  String _selectedProvider = 'libretranslate';
  String _selectedTargetLang = 'id';
  bool _isSaving = false;
  bool _isTesting = false;
  ({bool success, String message, int? latencyMs})? _testResult;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final settings = ref.read(appSettingsProvider);
      _selectedProvider = settings.activeProviderId;
      _selectedTargetLang = settings.targetLanguage;
      _serverController = TextEditingController(text: settings.gatewayUrl);
      _byokKeyController = TextEditingController(text: settings.byokKey);
      _byokEndpointController = TextEditingController(text: settings.byokEndpoint);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _serverController.dispose();
    _byokKeyController.dispose();
    _byokEndpointController.dispose();
    super.dispose();
  }

  Future<void> _handleTestConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final repo = ref.read(settingsRepositoryProvider);
    final result = await repo.testConnection(_serverController.text);

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testResult = result;
      });
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final newSettings = ref.read(appSettingsProvider).copyWith(
          gatewayUrl: _serverController.text.trim(),
          activeProviderId: _selectedProvider,
          byokKey: _byokKeyController.text.trim(),
          byokEndpoint: _byokEndpointController.text.trim(),
          targetLanguage: _selectedTargetLang,
        );

    await ref.read(appSettingsProvider.notifier).save(newSettings);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Pengaturan berhasil disimpan!')),
            ],
          ),
          backgroundColor: Colors.teal.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Integrasi'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Simpan',
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save_rounded),
            onPressed: _isSaving ? null : _handleSave,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // FOSS Commitment Card
          Card(
            elevation: 0,
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified_user_rounded, color: Colors.green.shade800, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '100% Gratis & 100% FOSS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Alinea berprinsip \$0 biaya marginal. Mesin translasi default ditenagai oleh LibreTranslate & model Argos Translate (MIT).',
                          style: TextStyle(fontSize: 12.5, color: Colors.green.shade800, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SECTION 1: Gateway & Connection
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.router_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Alamat Translation Gateway',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masukkan URL server gateway PC Anda jika menggunakan koneksi Wi-Fi yang sama.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),

                  // URL TextField
                  TextField(
                    controller: _serverController,
                    decoration: InputDecoration(
                      labelText: 'Gateway Base URL',
                      hintText: 'http://192.168.1.x:8000/v1',
                      prefixIcon: const Icon(Icons.link_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Helper Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.phone_android_rounded, size: 14),
                        label: const Text('Emulator (10.0.2.2)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          _serverController.text = 'http://10.0.2.2:8000/v1';
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.computer_rounded, size: 14),
                        label: const Text('Localhost (8000)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          _serverController.text = 'http://localhost:8000/v1';
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Test Connection Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isTesting ? null : _handleTestConnection,
                      icon: _isTesting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering_rounded, size: 18),
                      label: Text(_isTesting ? 'Menguji koneksi...' : 'Uji Koneksi Gateway'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),

                  // Connection Test Result Banner
                  if (_testResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _testResult!.success ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _testResult!.success ? Colors.green.shade300 : Colors.red.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _testResult!.success ? Icons.check_circle_rounded : Icons.error_rounded,
                            color: _testResult!.success ? Colors.green.shade700 : Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _testResult!.success && _testResult!.latencyMs != null
                                  ? '${_testResult!.message} (${_testResult!.latencyMs} ms)'
                                  : _testResult!.message,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _testResult!.success ? Colors.green.shade900 : Colors.red.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SECTION 2: Provider Choice
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Pilihan Mesin Translasi',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Option 1: LibreTranslate
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedProvider == 'libretranslate'
                            ? theme.colorScheme.primary
                            : Colors.grey.shade300,
                        width: _selectedProvider == 'libretranslate' ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      value: 'libretranslate',
                      groupValue: _selectedProvider,
                      title: const Row(
                        children: [
                          Text('LibreTranslate Self-Hosted', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          Chip(
                            label: Text('DEFAULT FOSS', style: TextStyle(fontSize: 10, color: Colors.green)),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      subtitle: const Text('Model Argos Translate open-source tanpa biaya API per-karakter.'),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvider = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Option 2: BYOK
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedProvider == 'byok'
                            ? theme.colorScheme.primary
                            : Colors.grey.shade300,
                        width: _selectedProvider == 'byok' ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      value: 'byok',
                      groupValue: _selectedProvider,
                      title: const Text('Bring Your Own Key (BYOK)', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Gunakan API key vendor pihak ketiga milik Anda sendiri (DeepL).'),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvider = val);
                      },
                    ),
                  ),

                  // BYOK sub-inputs
                  if (_selectedProvider == 'byok') ...[
                    const SizedBox(height: 14),
                    TextField(
                      controller: _byokKeyController,
                      decoration: InputDecoration(
                        labelText: 'API Key DeepL',
                        prefixIcon: const Icon(Icons.key_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SECTION 3: Target Language
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.translate_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Bahasa Target Terjemahan',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedTargetLang,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'id', child: Text('🇮🇩 Bahasa Indonesia (id)')),
                      DropdownMenuItem(value: 'en', child: Text('🇬🇧 English (en)')),
                      DropdownMenuItem(value: 'ja', child: Text('🇯🇵 Japanese (ja)')),
                      DropdownMenuItem(value: 'zh', child: Text('🇨🇳 Chinese (zh)')),
                      DropdownMenuItem(value: 'de', child: Text('🇩🇪 German (de)')),
                      DropdownMenuItem(value: 'fr', child: Text('🇫🇷 French (fr)')),
                      DropdownMenuItem(value: 'es', child: Text('🇪🇸 Spanish (es)')),
                      DropdownMenuItem(value: 'ar', child: Text('🇸🇦 Arabic (ar)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTargetLang = val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SECTION 4: Theme & Eye Comfort
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Tema Tampilan & Kenyamanan Mata',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih tema yang paling nyaman dan ramah di mata untuk sesi membaca panjang.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),

                  Consumer(
                    builder: (context, ref, _) {
                      final currentTheme = ref.watch(readingThemeModeProvider);
                      return Row(
                        children: [
                          _buildThemeOption(
                            label: 'Light',
                            sub: 'Siang Hari',
                            bg: const Color(0xFFF9F9FB),
                            textColor: const Color(0xFF1E293B),
                            borderColor: Colors.grey.shade400,
                            mode: ReadingThemeMode.light,
                            current: currentTheme,
                          ),
                          const SizedBox(width: 8),
                          _buildThemeOption(
                            label: 'Sepia',
                            sub: 'Anti-Lelah',
                            bg: const Color(0xFFF7F1E3),
                            textColor: const Color(0xFF4A3B32),
                            borderColor: const Color(0xFFD4C7AB),
                            mode: ReadingThemeMode.sepia,
                            current: currentTheme,
                          ),
                          const SizedBox(width: 8),
                          _buildThemeOption(
                            label: 'Dark',
                            sub: 'Malam',
                            bg: const Color(0xFF121820),
                            textColor: const Color(0xFFE2E8F0),
                            borderColor: const Color(0xFF2C3E50),
                            mode: ReadingThemeMode.dark,
                            current: currentTheme,
                          ),
                          const SizedBox(width: 8),
                          _buildThemeOption(
                            label: 'AMOLED',
                            sub: 'Hemat Baterai',
                            bg: Colors.black,
                            textColor: const Color(0xFFE0E0E0),
                            borderColor: const Color(0xFF333333),
                            mode: ReadingThemeMode.amoled,
                            current: currentTheme,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // SECTION: Glosarium & Istilah
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Kamus Glosarium & Istilah',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kunci dan kelola terjemahan istilah khusus agar selalu diterjemahkan konsisten di setiap buku.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                      );
                    },
                    icon: const Icon(Icons.auto_stories_rounded, size: 18),
                    label: const Text('Buka Pengelola Glosarium'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Penyimpanan Cache Lokal (Drift)',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cache terjemahan tersimpan secara lokal dan otomatis dipanggil instan (<200ms) tanpa jaringan.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final cacheRepo = ref.read(translationCacheRepositoryProvider);
                      final deleted = await cacheRepo.evictOldestEntries(maxEntries: 0, evictCount: 100000);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$deleted entri cache translasi telah dibersihkan.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                    label: const Text('Bersihkan Seluruh Cache'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section with App Logo
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Alinea',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                Text(
                  'Versi 1.0.0 (FOSS Edition)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Read first, translate seamlessly when needed.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required String sub,
    required Color bg,
    required Color textColor,
    required Color borderColor,
    required ReadingThemeMode mode,
    required ReadingThemeMode current,
  }) {
    final isSelected = mode == current;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(readingThemeModeProvider.notifier).state = mode;
          ref.read(appSettingsProvider.notifier).save(
                ref.read(appSettingsProvider).copyWith(readingTheme: mode.name),
              );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : borderColor,
              width: isSelected ? 2.2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Icon(Icons.check_circle_rounded, size: 16, color: Theme.of(context).colorScheme.primary)
              else
                const SizedBox(height: 16),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 9,
                  color: textColor.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

