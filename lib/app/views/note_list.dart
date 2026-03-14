import 'package:flutter/material.dart';
import 'package:notasapp/app/models/note.dart';
import 'package:notasapp/app/views/note_form.dart';
import 'package:notasapp/app/widgets/note_card.dart';
import 'package:notasapp/app/widgets/appbar.dart';
import 'package:notasapp/app/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import 'package:notasapp/app/viewmodels/note_view_model.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteViewModel>().loadNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar('NotasApp'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          AppSearchBar(
            controller: _searchController,
            onChanged: context.read<NoteViewModel>().searchNotes,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Solo fijadas'),
                  selected: viewModel.pinnedOnly,
                  onSelected: viewModel.setPinnedOnly,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildContent(viewModel)),
        ],
      ),
    );
  }

  Widget _buildContent(NoteViewModel viewModel) {
    final notes = viewModel.notes;

    if (viewModel.status == NoteStatus.loading && notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.status == NoteStatus.error && notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(viewModel.errorMessage ?? 'No se pudieron cargar las notas'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<NoteViewModel>().loadNotes(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (notes.isEmpty) {
      return const Center(
        child: Text('No hay notas. Presiona + para crear la primera.'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: notes.length,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onEdit: () => _openForm(context, note: note),
          onDelete: () => _confirmDelete(context, note),
          onTogglePin: () => context.read<NoteViewModel>().togglePin(note.id),
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, {Note? note}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NoteForm(initialNote: note)),
    );

    if (changed == true && mounted) {
      await context.read<NoteViewModel>().loadNotes();
    }
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('Se eliminara "${note.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    await context.read<NoteViewModel>().deleteNote(note.id);
  }
}
