import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';

class TaskWorkView extends StatefulWidget {
  final TaskController taskController;
  final Task task;

  TaskWorkView({required this.taskController, required this.task});

  @override
  _TaskWorkViewState createState() => _TaskWorkViewState();
}

class _TaskWorkViewState extends State<TaskWorkView> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mengerjakan Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Inputan Pesan
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Pesan'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            // Tombol Selesai
            ElevatedButton(
              onPressed: _completeTask,
              child: Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  void _completeTask() async {
    String message = messageController.text;

    bool success =
        await widget.taskController.completeTask(widget.task, message);

    if (success) {
      // Jika berhasil, kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      // Jika gagal, beri tahu pengguna atau lakukan penanganan kesalahan lainnya
      // ...
    }
  }
}
