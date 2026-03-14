import 'package:flutter/material.dart';
import 'package:notasapp/app/viewmodels/note_view_model.dart';
import 'package:notasapp/app/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const AppSearchBar({this.controller, this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<NoteViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextFieldWidget(
        controller: controller,
        onChanged: onChanged,
        hintText: "Buscar notas...",
        borderSide: BorderSide.none,
        prefixIcon: Icons.search,
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                onPressed: () => {controller?.clear(), vm.searchNotes('')},
                icon: Icon(Icons.close),
              )
            : null,
      ),
    );
  }
}
