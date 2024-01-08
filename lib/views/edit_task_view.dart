import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';

// ... bagian import dan deklarasi lainnya

class UpdateTaskView extends StatefulWidget {
  final TaskController taskController;
  final Task task;

  UpdateTaskView({required this.taskController, required this.task});

  @override
  _UpdateTaskViewState createState() => _UpdateTaskViewState();
}

class _UpdateTaskViewState extends State<UpdateTaskView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul Tugas'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi Tugas'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateTask(context);
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask(BuildContext context) {
    Task updatedTask = Task.optional(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: widget.task.date,
    );

    widget.taskController.updateTask(widget.task.id, updatedTask);

    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }
}
