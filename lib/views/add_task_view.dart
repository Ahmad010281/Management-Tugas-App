import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';
import 'dart:core';

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
                    widget.taskController.addTask(task).then((success) {
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        // Handle error or show a message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Failed to add task. Please try again.'),
                        ));
                      }
                    });
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
