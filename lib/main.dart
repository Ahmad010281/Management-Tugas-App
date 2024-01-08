import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'controllers/controller.dart';
import 'views/views.dart';
import 'views/login_view.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  final TaskController taskController = TaskController();
  final Dio dio = Dio();

  TaskApp() {
    dio.options.baseUrl =
        'https://64a2391db45881cc0ae4e4c1.mockapi.io'; // Ganti dengan URL API Anda
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatatan Tugas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskHomePage(taskController: taskController),
      routes: {
        '/login': (context) => LoginView(taskController: taskController),
        '/main': (context) => TaskHomePage(taskController: taskController),
      },
    );
  }
}

class TaskHomePage extends StatefulWidget {
  final TaskController taskController;

  TaskHomePage({required this.taskController});

  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.taskController.fetchTasks();
  }

  void _onTabSelected(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddTaskView(taskController: widget.taskController),
        ),
      );
    }
  }

  void _performLogout() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencatatan Tugas App'),
        actions: [
          IconButton(
            onPressed: _performLogout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: (_selectedIndex == 0)
          ? TaskListView(taskController: widget.taskController)
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Daftar Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Tugas',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
