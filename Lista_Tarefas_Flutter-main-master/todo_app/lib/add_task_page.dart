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
            _buildTextField('Título da Tarefa', 'Digite o título da tarefa', _titleController),
            SizedBox(height: 20),
            _buildTextField('Categoria', 'Digite a categoria da tarefa', _categoryController),
            SizedBox(height: 20),
            _buildDropdown('Prioridade', _selectedPriority, (Priority? value) {
              setState(() {
                _selectedPriority = value!;
              });
            }),
            SizedBox(height: 20),
            _buildDatePicker(context, 'Data de Vencimento', _selectedDate, () {
              _selectDate(context);
            }),
            SizedBox(height: 30),
            _buildElevatedButton(context, 'Adicionar Tarefa', Icons.add, () {
              Provider.of<TaskProvider>(context, listen: false).addTask(
                _titleController.text,
                _categoryController.text,
                _selectedDate,
                _selectedPriority,
                false,
              );
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, Priority value, ValueChanged<Priority?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<Priority>(
          value: value,
          onChanged: onChanged,
          items: Priority.values.map((Priority priority) {
            return DropdownMenuItem<Priority>(
              value: priority,
              child: Text(
                priority.toString().split('.').last,
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
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
                  date == null ? 'Selecione uma data' : date.toString().split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildElevatedButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
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
