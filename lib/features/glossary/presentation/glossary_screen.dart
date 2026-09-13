// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class GlossaryScreen extends ConsumerStatefulWidget {
  final int? bookId;
  final String? bookTitle;

  const GlossaryScreen({
    super.key,
    this.bookId,
    this.bookTitle,
  });

  @override
  ConsumerState<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends ConsumerState<GlossaryScreen> {
  List<GlossaryTerm> _terms = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterScope = 'all'; // 'all', 'global', 'book'

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    setState(() => _isLoading = true);
    final repo = ref.read(glossaryRepositoryProvider);
    final terms = await repo.getTerms(bookId: widget.bookId);
    if (mounted) {
      setState(() {
        _terms = terms;
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddOrEditDialog({GlossaryTerm? existingTerm}) async {
    final isEditing = existingTerm != null;
    final sourceController = TextEditingController(text: existingTerm?.sourceTerm ?? '');
    final translationController = TextEditingController(text: existingTerm?.preferredTranslation ?? '');
    String sourceLang = existingTerm?.sourceLanguage ?? 'en';
    String targetLang = existingTerm?.targetLanguage ?? 'id';
    bool isGlobal = existingTerm != null ? existingTerm.bookId == null : (widget.bookId == null);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(isEditing ? Icons.edit_note_rounded : Icons.bookmark_add_rounded,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(isEditing ? 'Ubah Istilah' : 'Tambah Istilah Baru',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: sourceController,
                    decoration: InputDecoration(
                      labelText: 'Istilah Asal',
                      hintText: 'Contoh: Machine Learning',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: translationController,
                    decoration: InputDecoration(
                      labelText: 'Terjemahan Pilihan',
                      hintText: 'Contoh: Pembelajaran Mesin',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: sourceLang,
                          decoration: InputDecoration(
                            labelText: 'Bahasa Asal',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('EN (Inggris)')),
                            DropdownMenuItem(value: 'ja', child: Text('JA (Jepang)')),
                            DropdownMenuItem(value: 'zh', child: Text('ZH (Mandarin)')),
                            DropdownMenuItem(value: 'de', child: Text('DE (Jerman)')),
                            DropdownMenuItem(value: 'fr', child: Text('FR (Prancis)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setDialogState(() => sourceLang = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: targetLang,
                          decoration: InputDecoration(
                            labelText: 'Bahasa Tujuan',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'id', child: Text('ID (Indonesia)')),
                            DropdownMenuItem(value: 'en', child: Text('EN (Inggris)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setDialogState(() => targetLang = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (widget.bookId != null) ...[
                    const SizedBox(height: 14),
                    const Text('Cakupan Istilah:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    RadioListTile<bool>(
                      title: const Text('Hanya Buku Ini', style: TextStyle(fontSize: 13)),
                      subtitle: Text(widget.bookTitle ?? 'Buku Saat Ini', style: const TextStyle(fontSize: 11)),
                      value: false,
                      groupValue: isGlobal,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setDialogState(() => isGlobal = val!),
                    ),
                    RadioListTile<bool>(
                      title: const Text('Global (Semua Buku)', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Diterapkan ke seluruh pembacaan buku', style: TextStyle(fontSize: 11)),
                      value: true,
                      groupValue: isGlobal,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setDialogState(() => isGlobal = val!),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  if (sourceController.text.trim().isEmpty || translationController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Istilah asal dan terjemahan tidak boleh kosong.')),
                    );
                    return;
                  }
                  Navigator.pop(ctx, true);
                },
                child: Text(isEditing ? 'Simpan' : 'Tambah'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(glossaryRepositoryProvider);
      final bookIdToUse = isGlobal ? null : widget.bookId;
      await repo.setTerm(
        bookId: bookIdToUse,
        sourceTerm: sourceController.text.trim(),
        preferredTranslation: translationController.text.trim(),
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
      );
      await _loadTerms();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Istilah "${sourceController.text.trim()}" berhasil disimpan!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteTerm(GlossaryTerm term) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Istilah?'),
        content: Text('Yakin ingin menghapus istilah "${term.sourceTerm}" dari glosarium?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(glossaryRepositoryProvider);
      await repo.deleteTerm(term.id);
      await _loadTerms();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Istilah telah dihapus.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredTerms = _terms.where((term) {
      if (_filterScope == 'global' && term.bookId != null) return false;
      if (_filterScope == 'book' && term.bookId == null) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchSrc = term.sourceTerm.toLowerCase().contains(q);
        final matchTrg = term.preferredTranslation.toLowerCase().contains(q);
        return matchSrc || matchTrg;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kamus Glosarium Istilah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              widget.bookTitle != null ? 'Buku: ${widget.bookTitle}' : 'Koleksi Istilah Terkunci',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Istilah'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari istilah atau terjemahan...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua (${_terms.length})', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Global (${_terms.where((t) => t.bookId == null).length})',
                        'global',
                      ),
                      if (widget.bookId != null) ...[
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Buku Ini (${_terms.where((t) => t.bookId == widget.bookId).length})',
                          'book',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTerms.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                        itemCount: filteredTerms.length,
                        itemBuilder: (context, index) {
                          final term = filteredTerms[index];
                          final isGlobal = term.bookId == null;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isGlobal ? Colors.blue.shade100 : Colors.teal.shade100,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isGlobal ? Colors.blue.shade50 : Colors.teal.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isGlobal ? '🌐 GLOBAL' : '📖 BUKU INI',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isGlobal ? Colors.blue.shade800 : Colors.teal.shade800,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${term.sourceLanguage.toUpperCase()} → ${term.targetLanguage.toUpperCase()}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              term.sourceTerm,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const Icon(Icons.arrow_forward_rounded,
                                                    size: 14, color: Colors.teal),
                                                const SizedBox(width: 4),
                                                Text(
                                                  term.preferredTranslation,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.teal.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, size: 20),
                                            tooltip: 'Ubah',
                                            onPressed: () => _showAddOrEditDialog(existingTerm: term),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                            tooltip: 'Hapus',
                                            onPressed: () => _handleDeleteTerm(term),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String scope) {
    final isSelected = _filterScope == scope;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _filterScope = scope);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Istilah Glosarium',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Glosarium mengunci terjemahan istilah tertentu secara konsisten (misal: "AI" selalu diterjemahkan "Kecerdasan Buatan").\n\nTekan tombol di bawah untuk menambah istilah baru.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
