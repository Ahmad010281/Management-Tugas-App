import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';
import 'package:flutter_uji_coba/views/task_detail_view.dart';

import 'package:flutter_uji_coba/views/edit_task_view.dart';

class TaskListView extends StatelessWidget {
  final TaskController taskController;

  TaskListView({required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tugas'),
      ),
      body: ListView.builder(
        itemCount: taskController.tasks.length,
        itemBuilder: (context, index) {
          Task task = taskController.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle:
                task.description.isNotEmpty ? Text(task.description) : null,
            onTap: () {
              // Navigasi ke halaman detail tugas
              _navigateToTaskDetailView(context, task);
            },
            onLongPress: () {
              // Tampilkan menu untuk mengedit atau menghapus tugas
              _showTaskOptions(context, task);
            },
          );
        },
      ),
    );
  }

  void _navigateToTaskDetailView(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailView(taskController: taskController, task: task),
      ),
    );
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Tugas'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                _navigateToEditTask(context, task);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Hapus Tugas'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                _showDeleteConfirmation(context, task);
              },
            ),
          ],
        );
      },
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
  }
}
