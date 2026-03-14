import 'package:flutter/material.dart';
import 'package:notasapp/app/repositories/sqlite_note_repository.dart';
import 'package:notasapp/app/viewmodels/note_view_model.dart';
import 'package:notasapp/app/views/note_list.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteViewModel(SqliteNoteRepository()),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const NoteList(),
      ),
    );
  }
}
