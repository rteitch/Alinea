import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../glossary/presentation/glossary_screen.dart';
import '../../translation/presentation/translation_history_screen.dart';
import 'about_screen.dart';
import 'language_picker_screen.dart';

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
  bool _autoDetectLanguage = true;
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
      _autoDetectLanguage = settings.autoDetectLanguage;
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
          autoDetectLanguage: _autoDetectLanguage,
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
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF132A1C)
                : Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF22543D)
                    : Colors.green.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF1E4620)
                          : Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF68D391)
                          : Colors.green.shade800,
                      size: 24,
                    ),
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
                            color: theme.brightness == Brightness.dark
                                ? const Color(0xFF9AE6B4)
                                : Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Alinea berprinsip \$0 biaya marginal. Mesin translasi default ditenagai oleh LibreTranslate & model Argos Translate (MIT).',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: theme.brightness == Brightness.dark
                                ? const Color(0xFFC6F6D5)
                                : Colors.green.shade800,
                            height: 1.3,
                          ),
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
                  const SizedBox(height: 6),
                  Text(
                    'Pilih mesin translasi yang ingin digunakan. FOSS Cloud gratis tanpa batas, Self-Hosted butuh PC aktif.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),

                  // Option 1: Alinea FOSS Cloud
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedProvider == 'foss_cloud'
                            ? theme.colorScheme.primary
                            : Colors.grey.shade300,
                        width: _selectedProvider == 'foss_cloud' ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      value: 'foss_cloud',
                      groupValue: _selectedProvider,
                      title: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Alinea FOSS Cloud',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.green.withAlpha(120)),
                            ),
                            child: const Text(
                              'SIAP PAKAI (\$0)',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: const Text('Bebas biaya tanpa batas. Siap dipakai langsung di ponsel via Wi-Fi & data seluler.'),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvider = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Option 2: LibreTranslate Self-Hosted
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
                      title: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'LibreTranslate Self-Hosted',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue.withAlpha(120)),
                            ),
                            child: const Text(
                              'LOKAL PC / DOCKER',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: const Text('Model Argos Translate mandiri. Memerlukan gateway aktif di komputer Anda.'),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvider = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Option 3: BYOK
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
                      title: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Bring Your Own Key (BYOK)',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.orange.withAlpha(120)),
                            ),
                            child: const Text(
                              'API KEY',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                        'Bahasa Terjemahan',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Atur bahasa sumber (otomatis dari metadata EPUB) dan bahasa target terjemahan.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),

                  // Auto-detect toggle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _autoDetectLanguage
                          ? theme.colorScheme.primaryContainer.withAlpha(40)
                          : theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _autoDetectLanguage
                            ? theme.colorScheme.primary.withAlpha(80)
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_fix_high_rounded,
                          size: 20,
                          color: _autoDetectLanguage
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deteksi Bahasa Sumber Otomatis',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _autoDetectLanguage
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bahasa sumber dideteksi otomatis dari teks. Matikan jika ingin pakai metadata EPUB.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _autoDetectLanguage,
                          onChanged: (val) => setState(() => _autoDetectLanguage = val),
                        ),
                      ],
                    ),
                  ),

                  // Language picker button (shown when auto-detect is enabled)
                  if (_autoDetectLanguage) ...[
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, _) {
                        final detectionLangs = ref.watch(detectionLanguagesProvider);
                        return OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LanguagePickerScreen()),
                            );
                          },
                          icon: const Icon(Icons.language_rounded, size: 18),
                          label: Text(
                            '${detectionLangs.length} bahasa dipilih',
                            style: const TextStyle(fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Target language dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedTargetLang,
                    decoration: InputDecoration(
                      labelText: 'Bahasa Target',
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

          // SECTION 3.5: Translation Style
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
                        'Gaya Terjemahan',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Natural mengalir seperti bahasa asli, Literal mempertahankan struktur asli, Akademis cocok untuk riset.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  Consumer(
                    builder: (context, ref, _) {
                      final currentStyle = ref.watch(appSettingsProvider).translationStyle;
                      return Row(
                        children: [
                          _buildTranslationStyleChip(context, ref, 'Natural', 'natural', currentStyle),
                          const SizedBox(width: 8),
                          _buildTranslationStyleChip(context, ref, 'Literal', 'literal', currentStyle),
                          const SizedBox(width: 8),
                          _buildTranslationStyleChip(context, ref, 'Akademis', 'academic', currentStyle),
                        ],
                      );
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
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
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
                          _buildThemeOption(
                            label: 'Sepia',
                            sub: 'Anti-Lelah',
                            bg: const Color(0xFFF7F1E3),
                            textColor: const Color(0xFF4A3B32),
                            borderColor: const Color(0xFFD4C7AB),
                            mode: ReadingThemeMode.sepia,
                            current: currentTheme,
                          ),
                          _buildThemeOption(
                            label: 'Dark',
                            sub: 'Malam',
                            bg: const Color(0xFF121820),
                            textColor: const Color(0xFFE2E8F0),
                            borderColor: const Color(0xFF2C3E50),
                            mode: ReadingThemeMode.dark,
                            current: currentTheme,
                          ),
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
          // SECTION: Riwayat Terjemahan & Kosakata
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
                      Icon(Icons.history_edu_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Riwayat Terjemahan & Kosakata',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tinjau kembali kata dan kalimat yang pernah Anda terjemahkan saat membaca buku sebagai catatan belajar bahasa.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TranslationHistoryScreen()),
                      );
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('Buka Riwayat Terjemahan'),
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

          // SECTION 5: App Language
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
                      Icon(Icons.language_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Bahasa Aplikasi',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih bahasa antarmuka aplikasi.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  Consumer(
                    builder: (context, ref, _) {
                      final currentLocale = ref.watch(localeProvider);
                      return Row(
                        children: [
                          _buildLanguageChip(context, ref, 'Indonesia', 'id', currentLocale),
                          const SizedBox(width: 8),
                          _buildLanguageChip(context, ref, 'English', 'en', currentLocale),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data Management
          const Text('Manajemen Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup_rounded),
                  title: const Text('Backup Database'),
                  subtitle: const Text('Simpan semua data ke file backup'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform.saveFile(
                        dialogTitle: 'Simpan Backup Database',
                        fileName: 'alinea_backup_${DateTime.now().millisecondsSinceEpoch}.sqlite',
                        type: FileType.custom,
                        allowedExtensions: ['sqlite'],
                      );
                      if (result == null) return;
                      final repo = ref.read(bookRepositoryProvider);
                      await repo.backupDatabase(result);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Backup tersimpan: ${result.split(Platform.pathSeparator).last}'),
                            backgroundColor: Colors.green.shade700,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal backup: $e')),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_rounded),
                  title: const Text('Restore Database'),
                  subtitle: const Text('Pulihkan data dari file backup'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['sqlite'],
                      );
                      if (result == null || result.files.isEmpty) return;
                      final filePath = result.files.first.path;
                      if (filePath == null) return;

                      // Confirm dialog
                      if (!context.mounted) return;
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Restore Database?'),
                          content: const Text(
                            'Semua data saat ini akan diganti. App akan restart setelah restore. Lanjutkan?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Restore'),
                            ),
                          ],
                        ),
                      );
                      if (confirm != true) return;

                      final repo = ref.read(bookRepositoryProvider);
                      await repo.restoreDatabase(filePath);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Database dipulihkan. Restart app...'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Restart app
                        await Future.delayed(const Duration(seconds: 1));
                        if (context.mounted) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const _RestartScreen(),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal restore: $e')),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Tentang Alinea'),
                  subtitle: const Text('Versi, lisensi, dan tautan'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
    return SizedBox(
      width: 72,
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
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationStyleChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    String value,
    String currentStyle,
  ) {
    final isSelected = currentStyle == value;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (_) {
        ref.read(appSettingsProvider.notifier).save(
              ref.read(appSettingsProvider).copyWith(translationStyle: value),
            );
      },
    );
  }

  Widget _buildLanguageChip(BuildContext context, WidgetRef ref, String label, String code, Locale currentLocale) {
    final isSelected = currentLocale.languageCode == code;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (_) {
        ref.read(localeProvider.notifier).state = Locale(code);
      },
    );
  }
}

/// Simple screen that shows a loading indicator while the app restarts
class _RestartScreen extends StatelessWidget {
  const _RestartScreen();

  @override
  Widget build(BuildContext context) {
    // Auto-restart after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        // Navigate back to splash, which will re-navigate to library
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const _SplashAfterRestore(),
          ),
          (route) => false,
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memulihkan database...'),
          ],
        ),
      ),
    );
  }
}

/// Splash screen after restore - navigates to library
class _SplashAfterRestore extends StatelessWidget {
  const _SplashAfterRestore();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        // Import the library screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const _LibraryAfterRestore(),
          ),
          (route) => false,
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Library screen wrapper after restore
class _LibraryAfterRestore extends ConsumerWidget {
  const _LibraryAfterRestore();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Import library screen dynamically to avoid circular imports
    // We'll use a simple approach: just show a message and let user navigate
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 64, color: Colors.green.shade600),
            const SizedBox(height: 16),
            const Text(
              'Database berhasil dipulihkan!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan restart app secara manual.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // Close and reopen - user can do this manually
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}

