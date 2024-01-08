import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';
import 'package:flutter_uji_coba/views/tugas_selesai.dart';

class UserTaskDetailView extends StatelessWidget {
  final TaskController taskController;
  final Task task;
  UserTaskDetailView({required this.taskController, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Konten Detail Tugas
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Waktu: ${task.date.toString()}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Tombol Mengerjakan Tugas
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskWorkView(
                    taskController: taskController,
                    task: task,
                  ),
                ),
              );
            },
            child: Text('Mengerjakan Tugas'),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          // ... (opsional)
          ),
    );
  }

  // ...
}
