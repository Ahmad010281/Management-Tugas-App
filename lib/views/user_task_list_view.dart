import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/model.dart';
import 'package:flutter_uji_coba/views/user_task_detail_view.dart';

class UserTaskListView extends StatelessWidget {
  final TaskController taskController;

  UserTaskListView({required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tugas'),
      ),
      body: FutureBuilder<List<Task>>(
        future: taskController.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada tugas.'));
          } else {
            List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {
                    _showTaskDetail(context, task);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserTaskDetailView(
          taskController: taskController,
          task: task,
        ),
      ),
    );
  }
}
