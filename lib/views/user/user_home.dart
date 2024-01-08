import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/views/user_task_list_view.dart';
import 'package:flutter_uji_coba/views/UserCompletedTaskListView.dart'; // Import halaman tugas selesai
import 'package:flutter_uji_coba/views/login_view.dart'; // Import halaman tugas selesai

class UserHomePage extends StatefulWidget {
  final TaskController taskController;

  UserHomePage({required this.taskController});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.taskController.fetchTasks();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _performLogout() {
    // Sinkronisasi data sebelum logout
    widget.taskController.fetchTasks();

    // Implement your logout logic here
    // ...

    // Example: Resetting the task controller

    // Navigating to the login page
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginView(taskController: widget.taskController)));
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return UserTaskListView(taskController: widget.taskController);
    } else if (_selectedIndex == 1) {
      return UserCompletedTaskListView(taskController: widget.taskController);
    } else {
      return Container(); // Ganti dengan widget atau halaman yang sesuai
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencatatan Tugas App (User)'),
        actions: [
          IconButton(
            onPressed: _performLogout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Daftar Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Tugas Selesai',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
