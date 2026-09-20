import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

/// Supported languages for detection with their names and flags.
const Map<String, ({String name, String flag})> kSupportedLanguages = {
  'en': (name: 'English', flag: '🇬🇧'),
  'id': (name: 'Bahasa Indonesia', flag: '🇮🇩'),
  'ja': (name: 'Japanese', flag: '🇯🇵'),
  'zh': (name: 'Chinese', flag: '🇨🇳'),
  'ko': (name: 'Korean', flag: '🇰🇷'),
  'de': (name: 'German', flag: '🇩🇪'),
  'fr': (name: 'French', flag: '🇫🇷'),
  'es': (name: 'Spanish', flag: '🇪🇸'),
  'pt': (name: 'Portuguese', flag: '🇵🇹'),
  'it': (name: 'Italian', flag: '🇮🇹'),
  'ru': (name: 'Russian', flag: '🇷🇺'),
  'ar': (name: 'Arabic', flag: '🇸🇦'),
  'th': (name: 'Thai', flag: '🇹🇭'),
  'vi': (name: 'Vietnamese', flag: '🇻🇳'),
  'tr': (name: 'Turkish', flag: '🇹🇷'),
  'pl': (name: 'Polish', flag: '🇵🇱'),
  'nl': (name: 'Dutch', flag: '🇳🇱'),
  'sv': (name: 'Swedish', flag: '🇸🇪'),
  'no': (name: 'Norwegian', flag: '🇳🇴'),
  'da': (name: 'Danish', flag: '🇩🇰'),
  'fi': (name: 'Finnish', flag: '🇫🇮'),
  'cs': (name: 'Czech', flag: '🇨🇿'),
  'el': (name: 'Greek', flag: '🇬🇷'),
  'hu': (name: 'Hungarian', flag: '🇭🇺'),
  'ro': (name: 'Romanian', flag: '🇷🇴'),
  'uk': (name: 'Ukrainian', flag: '🇺🇦'),
  'he': (name: 'Hebrew', flag: '🇮🇱'),
  'hi': (name: 'Hindi', flag: '🇮🇳'),
  'bn': (name: 'Bengali', flag: '🇧🇩'),
  'ms': (name: 'Malay', flag: '🇲🇾'),
  'tl': (name: 'Filipino', flag: '🇵🇭'),
};

class LanguagePickerScreen extends ConsumerStatefulWidget {
  const LanguagePickerScreen({super.key});

  @override
  ConsumerState<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends ConsumerState<LanguagePickerScreen> {
  late Set<String> _selectedLanguages;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    _selectedLanguages = Set<String>.from(settings.detectionLanguages);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredLanguages = kSupportedLanguages.entries.where((entry) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return entry.value.name.toLowerCase().contains(query) ||
          entry.key.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bahasa Deteksi'),
        actions: [
          // Select All
          TextButton(
            onPressed: () {
              setState(() {
                _selectedLanguages = Set<String>.from(kSupportedLanguages.keys);
              });
            },
            child: const Text('Semua'),
          ),
          // Clear All
          TextButton(
            onPressed: () {
              setState(() {
                _selectedLanguages.clear();
              });
            },
            child: const Text('Hapus'),
          ),
          // Save
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Simpan',
            onPressed: _selectedLanguages.isEmpty
                ? null
                : () {
                    ref.read(appSettingsProvider.notifier).save(
                          ref.read(appSettingsProvider).copyWith(
                                detectionLanguages: _selectedLanguages.toList(),
                              ),
                    );
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari bahasa...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Selected count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '${_selectedLanguages.length} bahasa dipilih',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Language list
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final entry = filteredLanguages[index];
                final code = entry.key;
                final name = entry.value.name;
                final flag = entry.value.flag;
                final isSelected = _selectedLanguages.contains(code);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedLanguages.add(code);
                      } else {
                        _selectedLanguages.remove(code);
                      }
                    });
                  },
                  title: Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        code.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: theme.colorScheme.primary,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
