import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';
import 'dart:core';

class TaskListView extends StatelessWidget {
  final TaskController taskController;

  TaskListView({required this.taskController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskController.tasks.length,
      itemBuilder: (context, index) {
        final task = taskController.tasks[index];
        return InkWell(
          onTap: () {
            _showTaskDetail(context, task);
          },
          onLongPress: () {
            _showDeleteConfirmationDialog(context, task.id);
          },
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.date.toString()),
          ),
        );
      },
    );
  }

  void _showTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailView(
          taskController: taskController,
          task: task,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Tugas'),
          content: Text('Apakah kamu yakin tugas akan dihapus?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                taskController
                    .deleteTask(taskId); // Menghapus task dari controller
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

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
              _editTask(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                child: Text('Hapus'),
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskView(
          taskController: taskController,
          task: task,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Tugas'),
          content: Text('Apakah kamu yakin tugas akan dihapus?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                taskController.deleteTask(task.id);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

class EditTaskView extends StatefulWidget {
  final TaskController taskController;
  final Task task;

  EditTaskView({required this.taskController, required this.task});

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _date = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedTask = Task(
                      id: widget.task.id,
                      title: _title,
                      description: _description,
                      date: _date,
                    );
                    widget.taskController
                        .updateTask(widget.task.id, updatedTask);
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTaskView extends StatefulWidget {
  final TaskController taskController;

  AddTaskView({required this.taskController});

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final task = Task(
                      id: DateTime.now().toString(),
                      title: _title,
                      description: _description,
                      date: DateTime.now(),
                    );
                    widget.taskController.addTask(task);
                    Navigator.pop(context);
                  }
                },
                child: Text('Tambah Tugas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
