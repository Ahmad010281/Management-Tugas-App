import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';
import 'package:flutter_uji_coba/views/edit_task_view.dart'; // Impor halaman edit tugas

class TaskDetailView extends StatelessWidget {
  final TaskController taskController;
  final Task task;

  TaskDetailView({required this.taskController, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEditTask(context, task);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, task);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Tugas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(task.title),
            SizedBox(height: 16.0),
            Text(
              'Deskripsi Tugas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(task.description),
            SizedBox(height: 16.0),
            Text(
              'Tanggal Tugas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(task.date
                .toString()), // Sesuaikan dengan format yang diinginkan
          ],
        ),
      ),
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateTaskView(taskController: taskController, task: task),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus Tugas'),
          content: Text('Anda yakin ingin menghapus tugas ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(context, task);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    taskController.deleteTask(task.id);
    Navigator.of(context).pop(); // Tutup dialog
    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }
}
