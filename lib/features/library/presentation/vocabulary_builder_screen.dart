import 'dart:math';
import 'package:drift/drift.dart' hide Column, OrderBy;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class VocabularyBuilderScreen extends ConsumerStatefulWidget {
  const VocabularyBuilderScreen({super.key});

  @override
  ConsumerState<VocabularyBuilderScreen> createState() => _VocabularyBuilderScreenState();
}

class _VocabularyBuilderScreenState extends ConsumerState<VocabularyBuilderScreen>
    with SingleTickerProviderStateMixin {
  List<GlossaryTerm> _terms = [];
  bool _loading = true;
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _reviewed = 0;
  int _correct = 0;
  int _again = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadTerms();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadTerms() async {
    final db = ref.read(databaseProvider);
    final terms = await (db.select(db.glossaryTerms)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();

    // Shuffle for review
    terms.shuffle(Random());

    setState(() {
      _terms = terms;
      _loading = false;
    });
  }

  void _nextCard() {
    setState(() {
      _showAnswer = false;
      _currentIndex = (_currentIndex + 1) % _terms.length;
    });
    _flipController.reset();
  }

  void _markCorrect() {
    setState(() {
      _reviewed++;
      _correct++;
    });
    _nextCard();
  }

  void _markAgain() {
    setState(() {
      _reviewed++;
      _again++;
    });
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kosakata'),
        actions: [
          if (_terms.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${_terms.length}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _terms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_rounded, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Belum ada kosakata', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        'Terjemahkan kata-kata saat membaca\nuntuk menambah kosakata',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Progress bar
                    if (_reviewed > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            _miniStat(Icons.check_circle_rounded, '$_correct', Colors.green),
                            const SizedBox(width: 12),
                            _miniStat(Icons.replay_rounded, '$_again', Colors.orange),
                            const Spacer(),
                            Text('$_reviewed ditinjau', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Flashcard
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _showAnswer = !_showAnswer);
                            if (_showAnswer) {
                              _flipController.forward();
                            } else {
                              _flipController.reverse();
                            }
                          },
                          child: AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              final isFront = _flipAnimation.value < 0.5;
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(_flipAnimation.value * pi),
                                child: isFront ? _buildFront() : _buildBack(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Action buttons
                    if (_showAnswer)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.replay_rounded, size: 18),
                                label: const Text('Ulang'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade100,
                                  foregroundColor: Colors.orange.shade800,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _markAgain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_rounded, size: 18),
                                label: const Text('Mudah'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  foregroundColor: Colors.green.shade800,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _markCorrect,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Ketuk untuk melihat jawaban',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildFront() {
    final term = _terms[_currentIndex];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(term.sourceLanguage.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 16),
            Text(
              term.sourceTerm,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Icon(Icons.touch_app_rounded, color: Colors.grey.shade500, size: 28),
            const SizedBox(height: 8),
            Text('Ketuk untuk membalik', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    final term = _terms[_currentIndex];
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade50,
                Colors.green.shade100,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(term.targetLanguage.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(height: 16),
              Text(
                term.preferredTranslation,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (term.bookId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${term.sourceTerm}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(value, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
