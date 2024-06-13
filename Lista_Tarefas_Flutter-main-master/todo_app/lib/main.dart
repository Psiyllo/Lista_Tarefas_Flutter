// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_provider.dart';
import 'add_task_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'App de Tarefas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/addTask': (context) => AddTaskPage(),
        },
      ),
    );
  }
}