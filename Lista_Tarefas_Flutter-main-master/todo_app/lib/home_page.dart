import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'task_provider.dart';
import 'task_detail_page.dart';

enum TaskStatusFilter { all, concluded, notConcluded }
enum PriorityFilter { all, low, medium, high }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  TaskStatusFilter _taskStatusFilter = TaskStatusFilter.notConcluded;
  PriorityFilter _priorityFilter = PriorityFilter.all;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Tarefas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          _buildTaskStatusFilterDropdown(),
          if (_taskStatusFilter == TaskStatusFilter.notConcluded)
            _buildPriorityFilterDropdown(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Consumer<TaskProvider>(
            builder: (context, provider, child) {
              List<Task> filteredTasks = _filterTasks(provider.tasks);
              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return _buildTaskCard(context, task, provider);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addTask'),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, TaskProvider provider) {
    Widget _buildCompletionTime() {
      if (task.isDone && task.completionTime != null) {
        Duration elapsed = DateTime.now().difference(task.completionTime!);
        return Text(
          'Concluída há: ${_formatElapsedTime(elapsed)}',
          style: TextStyle(fontSize: 14, color: Colors.red),
        );
      } else {
        return SizedBox.shrink();
      }
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    task.isFavorite ? FontWeight.bold : FontWeight.normal,
                color: task.isDone ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categoria: ${task.category}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Prioridade: ${task.priority.toString().split('.').last}',
                  style: TextStyle(fontSize: 16),
                ),
                _buildCompletionTime(),
              ],
            ),
            leading: Checkbox(
              value: task.isDone,
              onChanged: (bool? newValue) {
                provider.toggleTaskStatus(task.id);
              },
              activeColor: Colors.blue,
            ),
            trailing: Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: Icon(
                    task.isFavorite ? Icons.star : Icons.star_border,
                    color: task.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    provider.toggleTaskFavorite(task.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _navigateToTaskDetail(context, task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, task, provider);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
  List<Task> filteredTasks = tasks;

  if (_taskStatusFilter == TaskStatusFilter.concluded) {
    filteredTasks = tasks.where((task) => task.isDone).toList();
  } else if (_taskStatusFilter == TaskStatusFilter.notConcluded) {
    filteredTasks = tasks.where((task) => !task.isDone).toList();
    if (_priorityFilter != PriorityFilter.all) {
      filteredTasks = filteredTasks
          .where((task) => _priorityFromFilter(task.priority) == _priorityFilter)
          .toList();
    }
  }
  return filteredTasks;
}

  PriorityFilter _priorityFromFilter(Priority priority) {
    switch (priority) {
      case Priority.baixa:
        return PriorityFilter.low;
      case Priority.media:
        return PriorityFilter.medium;
      case Priority.alta:
        return PriorityFilter.high;
    }
  }

  String _formatElapsedTime(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} dias';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} horas';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutos';
    } else {
      return '${duration.inSeconds} segundos';
    }
  }

  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(task: task),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Task task, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir Tarefa"),
          content: Text("Tem certeza de que deseja excluir esta tarefa?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                provider.deleteTask(task.id);
                Navigator.pop(context);
              },
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskStatusFilterDropdown() {
    return PopupMenuButton<TaskStatusFilter>(
      initialValue: _taskStatusFilter,
      onSelected: (TaskStatusFilter result) {
        setState(() {
          _taskStatusFilter = result;
          _priorityFilter = PriorityFilter.all; // Limpar o filtro de prioridade ao mudar o status
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskStatusFilter>>[
        PopupMenuItem<TaskStatusFilter>(
          value: TaskStatusFilter.all,
          child: Text('Todas as Tarefas'),
        ),
        PopupMenuItem<TaskStatusFilter>(
          value: TaskStatusFilter.concluded,
          child: Text('Concluídas'),
        ),
        PopupMenuItem<TaskStatusFilter>(
          value: TaskStatusFilter.notConcluded,
          child: Text('Não Concluídas'),
        ),
      ],
    );
  }

  Widget _buildPriorityFilterDropdown() {
  return PopupMenuButton<PriorityFilter>(
    initialValue: _priorityFilter,
    onSelected: (PriorityFilter result) {
      setState(() {
        _priorityFilter = result;
      });
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<PriorityFilter>>[
      PopupMenuItem<PriorityFilter>(
        value: PriorityFilter.all,
        child: Text('Todas as Prioridades'),
      ),
      PopupMenuItem<PriorityFilter>(
        value: PriorityFilter.low,
        child: Text('Prioridade Baixa'),
      ),
      PopupMenuItem<PriorityFilter>(
        value: PriorityFilter.medium,
        child: Text('Prioridade Média'),
      ),
      PopupMenuItem<PriorityFilter>(
        value: PriorityFilter.high,
        child: Text('Prioridade Alta'),
      ),
    ],
  );
}
}