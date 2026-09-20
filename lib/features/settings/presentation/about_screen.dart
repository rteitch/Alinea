import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Alinea'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Alinea',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'v1.4.0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'FOSS EPUB Reader & In-Place Translation Engine',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            context,
            'Tentang',
            'Alinea adalah pembaca buku digital (EPUB) modern yang menghormati privasi. '
            'Membaca jangka panjang dengan terjemahan mesin di tempat yang didukung oleh '
            'mesin sumber terbuka (LibreTranslate + Argos Translate).',
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            'Fitur Utama',
            '• Parsing EPUB 2.0 & 3.0 native Dart\n'
            '• Terjemahan di tempat (Mode C)\n'
            '• Cache lokal content-addressed (LRU)\n'
            '• Glossary terminologi scope-scoped\n'
            '• 4 tema baca (Light, Sepia, Dark, AMOLED)\n'
            '• Highlight visual dalam teks\n'
            '• Catatan & ekspor Markdown\n'
            '• Text-to-Speech (TTS)\n'
            '• Sederhana & FOSS (\$0 biaya marjinal)',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'Tautan'),
          const SizedBox(height: 8),
          _buildLinkTile(
            context,
            icon: Icons.code_rounded,
            title: 'Source Code (GitHub)',
            subtitle: 'github.com/rteitch/Alinea',
          ),
          _buildLinkTile(
            context,
            icon: Icons.bug_report_rounded,
            title: 'Laporkan Bug',
            subtitle: 'GitHub Issues',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'Lisensi'),
          const SizedBox(height: 8),
          _buildLinkTile(
            context,
            icon: Icons.gavel_rounded,
            title: 'MIT License',
            subtitle: 'Alinea Client',
          ),
          _buildLinkTile(
            context,
            icon: Icons.gavel_rounded,
            title: 'AGPL-3.0',
            subtitle: 'LibreTranslate (Translation Engine)',
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            'Sumber Terbuka',
            'Alinea dibangun dengan widget Flutter, Drift (SQLite), '
            'Riverpod, dan mesin terjemahan sumber terbuka. '
            'Tidak ada biaya berlangganan atau API proprietar.',
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Dibuat dengan ❤ untuk pembaca buku digital',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: const Icon(Icons.copy_rounded, size: 18),
        onTap: () {
          final url = title.contains('Bug')
              ? 'https://github.com/rteitch/Alinea/issues'
              : 'https://github.com/rteitch/Alinea';
          Clipboard.setData(ClipboardData(text: url));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URL disalin ke clipboard')),
          );
        },
      ),
    );
  }
}
