import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'task_provider.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Priority _selectedPriority = Priority.baixa;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Tarefa"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildInfoRow('Categoria', widget.task.category),
            SizedBox(height: 20),
            _buildInfoRow(
                'Prioridade',
                widget.task.priority
                    .toString()
                    .split('.')
                    .last
                    .toUpperCase(),
                color: _priorityColor(widget.task.priority)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Concluída',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: widget.task.isDone,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.task.isDone = newValue ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildPriorityDropdown(),
            SizedBox(height: 20),
            _buildDatePicker(),
            SizedBox(height: 30),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 18,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atualizar Prioridade',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<Priority>(
          value: _selectedPriority,
          onChanged: (Priority? value) {
            setState(() {
              _selectedPriority = value!;
            });
          },
          items: Priority.values.map((Priority priority) {
            return DropdownMenuItem<Priority>(
              value: priority,
              child: Text(
                priority.toString().split('.').last.toUpperCase(),
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Vencimento',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Selecione uma data'
                      : _selectedDate!.toString().split(' ')[0],
                  style: TextStyle(fontSize: 18),
                ),
                Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<TaskProvider>(context, listen: false)
              .editTaskPriority(widget.task.id, _selectedPriority);
          Provider.of<TaskProvider>(context, listen: false)
              .editTaskDueDate(widget.task.id, _selectedDate);
          Navigator.pop(context);
        },
        child: Text(
          'Atualizar',
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.baixa:
        return Colors.green;
      case Priority.media:
        return Colors.orange;
      case Priority.alta:
        return Colors.red;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.task.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
