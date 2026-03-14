import 'package:flutter/material.dart';
import 'package:notasapp/app/models/note.dart';
import 'package:notasapp/app/viewmodels/note_view_model.dart';
import 'package:notasapp/app/widgets/appbar.dart';
import 'package:notasapp/app/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class NoteForm extends StatelessWidget {
  final Note? initialNote;

  const NoteForm({this.initialNote, super.key});

  bool get _isEditing => initialNote != null;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewModel>()..setInitialNote(initialNote);

    return Scaffold(
      appBar: MainAppBar(_isEditing ? 'Editar nota' : 'Agregar nota'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: vm.formKey,
            autovalidateMode: .onUserInteractionIfError,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                TextFieldWidget(
                  label: 'Titulo',
                  controller: vm.titleController,
                  validator: vm.validTitle,
                ),
                TextFieldWidget(
                  label: 'Contenido',
                  controller: vm.contentController,
                  minLines: 5,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                ),
                Selector<NoteViewModel, bool>(
                  selector: (_, vm) => vm.isSaving,
                  builder: (_, isSaving, child) => SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () => vm.formKey.currentState?.validate() == true
                                ? {
                                    vm.saveNote(
                                      id: initialNote?.id,
                                      title: vm.titleController.text,
                                      content: vm.contentController.text,
                                    ),
                                    Navigator.pop(context),
                                  }
                                : null,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: Text(isSaving ? 'Guardando...' : 'Guardar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
