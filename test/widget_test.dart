import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/app/app.dart';
import 'package:alinea/app/providers.dart';
import 'package:alinea/core/storage/database.dart';

void main() {
  testWidgets('AlineaApp smoke test: renders LibraryScreen, Title, and Import Button', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON;'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const AlineaApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify title and library screen elements
    expect(find.text('Alinea'), findsOneWidget);
    expect(find.text('READER'), findsOneWidget);
    expect(find.text('Import EPUB'), findsOneWidget);
    expect(find.text('Perpustakaan Masih Kosong'), findsOneWidget);

    await db.close();
  });
}
