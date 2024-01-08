import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/auth/auth.dart';
import 'package:flutter_uji_coba/views/login_view.dart';
import 'package:flutter_uji_coba/controllers/controller.dart'; // Sesuaikan dengan struktur proyek Anda
import 'package:flutter_uji_coba/views/add_task_view.dart';
import 'package:flutter_uji_coba/views/task_list_view.dart';
import 'package:flutter_uji_coba/views/AdminCompletedTaskListView.dart';

class AdminHomePage extends StatelessWidget {
  final TaskController taskController = TaskController();
  AdminHomePage() {
    taskController.fetchTasks(); // Mengambil dan menampilkan data tugas
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _performLogout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuItem(
              context,
              'Tambah Tugas',
              Icons.add,
              () {
                _navigateToAddTask(context);
              },
            ),
            _buildMenuItem(
              context,
              'Daftar Tugas',
              Icons.list,
              () {
                _navigateToTaskList(context);
              },
            ),
            _buildMenuItem(
              context,
              'Daftar User',
              Icons.people,
              () {
                _navigateToUserList(context);
              },
            ),
            _buildMenuItem(
              context,
              'Tugas Dikerjakan',
              Icons.check,
              () {
                _navigateToCompletedTasks(context);
              },
            ),

            // Tambahkan item menu lainnya jika diperlukan
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Function onTap) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: () {
          onTap();
        },
      ),
    );
  }

  void _performLogout(BuildContext context) {
    AuthController authController = AuthController();
    authController.logout();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginView(taskController: taskController)));
  }

  void _navigateToUserList(BuildContext context) {
    // Implementasi navigasi ke halaman Daftar User
    // Sesuaikan dengan halaman yang sesuai
  }

  void _navigateToCompletedTasks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminCompletedTaskListView(taskController: taskController),
      ),
    );
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTaskView(taskController: taskController)),
    );
  }

  void _navigateToTaskList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListView(taskController: taskController),
      ),
    );
  }
}
