import 'package:flutter/material.dart';
import 'task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get filteredTasks => _tasks;

  void addTask(String title, String category, DateTime? dueDate,
      Priority priority, bool isFavorite) {
    _tasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      category: category,
      dueDate: dueDate,
      priority: priority,
      isFavorite: isFavorite,
      completionTime: null, // Definindo inicialmente como null
    ));
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void editTask(int id, String newTitle, String newCategory,
      DateTime? newDueDate, Priority newPriority, bool newIsFavorite) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].title = newTitle;
      _tasks[taskIndex].category = newCategory;
      _tasks[taskIndex].dueDate = newDueDate;
      _tasks[taskIndex].priority = newPriority;
      _tasks[taskIndex].isFavorite = newIsFavorite;
      notifyListeners();
    }
  }

  void toggleTaskStatus(int id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isDone = !_tasks[taskIndex].isDone;
      if (_tasks[taskIndex].isDone) {
        _tasks[taskIndex].completionTime = DateTime.now(); // Definindo o tempo de conclusão
      } else {
        _tasks[taskIndex].completionTime = null; // Resetando o tempo de conclusão
      }
      notifyListeners();
    }
  }

  void toggleTaskFavorite(int id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isFavorite = !_tasks[taskIndex].isFavorite;
      notifyListeners();
    }
  }

  void setPriorityFilter(PriorityFilter priorityFilter) {
    List<Task> filteredTasks = [];
    switch (priorityFilter) {
      case PriorityFilter.all:
        filteredTasks = _tasks;
        break;
      case PriorityFilter.baixa:
        filteredTasks =
            _tasks.where((task) => task.priority == Priority.baixa).toList();
        break;
      case PriorityFilter.media:
        filteredTasks =
            _tasks.where((task) => task.priority == Priority.media).toList();
        break;
      case PriorityFilter.alta:
        filteredTasks =
            _tasks.where((task) => task.priority == Priority.alta).toList();
        break;
    }
    _tasks = filteredTasks;
    notifyListeners();
  }
}
