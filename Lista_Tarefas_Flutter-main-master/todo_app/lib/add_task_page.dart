// add_task_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../task.dart';
import '../task_provider.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  Priority _selectedPriority = Priority.baixa;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Tarefa"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da Tarefa
            Text(
              'Título da Tarefa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            // Campo de entrada para o título da tarefa
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Digite o título da tarefa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 20),
            // Categoria
            Text(
              'Categoria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            // Campo de entrada para a categoria da tarefa
            TextField(
              controller: _categoryController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Digite a categoria da tarefa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 20),
            // Prioridade
            Text(
              'Prioridade',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            // Dropdown para selecionar a prioridade
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
                    priority.toString().split('.').last,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Data de Vencimento
            Text(
              'Data de Vencimento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            // Campo para selecionar a data de vencimento
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
                          : _selectedDate!.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Botão para adicionar a tarefa
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).addTask(
                  _titleController.text,
                  _categoryController.text,
                  _selectedDate,
                  _selectedPriority,
                  false,
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.add, size: 24),
              label: Text(
                'Adicionar Tarefa',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
