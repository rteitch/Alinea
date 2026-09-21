import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class CreateCollectionDialog extends ConsumerStatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  ConsumerState<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends ConsumerState<CreateCollectionDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Koleksi Baru'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nama Koleksi',
          hintText: 'Misal: Fiksi, Sains, dll.',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () async {
            if (_controller.text.trim().isEmpty) return;
            final db = ref.read(databaseProvider);
            await db.createCollection(_controller.text.trim());
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Buat'),
        ),
      ],
    );
  }
}
