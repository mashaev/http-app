import 'package:flutter/material.dart';
import 'package:http_app/services/notes_services.dart';

import 'views/note_list.dart';
import 'package:get_it/get_it.dart';
void setupLocator(){
GetIt.I.registerLazySingleton(()=> NoteService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
