// task.dart

import 'package:tuple/tuple.dart';

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
  DateTime? completionTime;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.priority = Priority.baixa,
    required this.category,
    this.dueDate,
    this.isFavorite = false,
    this.completionTime,
  });
}

List<Task> filterTasksByPriority(List<Task> tasks, PriorityFilter filter) {
  switch (filter) {
    case PriorityFilter.baixa:
      return tasks.where((task) => task.priority == Priority.baixa).toList();
    case PriorityFilter.media:
      return tasks.where((task) => task.priority == Priority.media).toList();
    case PriorityFilter.alta:
      return tasks.where((task) => task.priority == Priority.alta).toList();
    case PriorityFilter.all:
      return tasks;
    default:
      throw Exception("Filtro de prioridade inválido");
  }
}

Tuple2<List<Task>, List<Task>> separateCompletedTasks(List<Task> tasks) {
  List<Task> completedTasks = tasks.where((task) => task.isDone).toList();
  List<Task> openTasks = tasks.where((task) => !task.isDone).toList();
  return Tuple2<List<Task>, List<Task>>(openTasks, completedTasks);
}
