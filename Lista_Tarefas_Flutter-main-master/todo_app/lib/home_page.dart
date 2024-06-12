import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'task_provider.dart';
import 'task_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Iniciar um timer para atualizar a tela a cada segundo
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        // Atualizar o estado para refletir a mudança de tempo
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancelar o timer quando o widget for descartado
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implementar a funcionalidade de busca
            },
          ),
          PopupMenuButton<PriorityFilter>(
            onSelected: (PriorityFilter result) {
              Provider.of<TaskProvider>(context, listen: false)
                  .setPriorityFilter(result);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<PriorityFilter>>[
              PopupMenuItem<PriorityFilter>(
                value: PriorityFilter.all,
                child: Text('Todas as Prioridades'),
              ),
              PopupMenuItem<PriorityFilter>(
                value: PriorityFilter.baixa,
                child: Text('Prioridade Baixa'),
              ),
              PopupMenuItem<PriorityFilter>(
                value: PriorityFilter.media,
                child: Text('Prioridade Média'),
              ),
              PopupMenuItem<PriorityFilter>(
                value: PriorityFilter.alta,
                child: Text('Prioridade Alta'),
              ),
            ],
          ),
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
              List<Task> filteredTasks = provider.filteredTasks;
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
        _buildCompletionTime(), // Chamando o método _buildCompletionTime fora do ListTile
      ],
    ),
  );
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
}
