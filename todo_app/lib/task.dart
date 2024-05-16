import 'package:flutter/material.dart';

enum Priority { baixa, media, alta }

enum PriorityFilter { all, baixa, media, alta }

class Task {
  int id;
  String title;
  bool isDone;
  Priority priority;
  String category;
  DateTime? dueDate;
  bool isFavorite;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.priority = Priority.baixa,
    required this.category,
    this.dueDate,
    this.isFavorite = false,
  });
}
