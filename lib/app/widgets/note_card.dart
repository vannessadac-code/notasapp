import 'package:flutter/material.dart';
import 'package:notasapp/app/models/note.dart';
import 'package:notasapp/core/action_enum.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 4,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontSize: 16, fontWeight: .w600),
                        ),
                      ),
                    ),
                    _buildPopupMenu(context),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      note.content,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: onTogglePin,
              icon: Icon(
                note.isPinned ? Icons.favorite : Icons.favorite_border,
                color: note.isPinned ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) => PopupMenuButton<MenuAction>(
    onSelected: (action) {
      if (action == MenuAction.edit) {
        onEdit();
        return;
      }

      onDelete();
    },
    itemBuilder: (context) => [
      _buildMenuItem(MenuAction.edit, label: "Editar", icon: Icons.edit),
      _buildMenuItem(MenuAction.delete, icon: Icons.delete, label: "Eliminar"),
    ],
  );

  PopupMenuItem<MenuAction> _buildMenuItem(
    MenuAction action, {
    required IconData icon,
    required String label,
  }) => PopupMenuItem(
    value: action,
    child: Row(children: [Icon(icon), const SizedBox(width: 8), Text(label)]),
  );
}
