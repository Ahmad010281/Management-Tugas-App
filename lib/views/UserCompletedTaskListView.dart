import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/completed_task.dart';
import 'package:url_launcher/url_launcher.dart'; // Import library url_launcher
import 'package:flutter/gestures.dart';

class UserCompletedTaskListView extends StatelessWidget {
  final TaskController taskController;

  UserCompletedTaskListView({required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Selesai'),
      ),
      body: FutureBuilder<List<CompletedTask>>(
        future: taskController.fetchCompletedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada tugas selesai.'));
          } else {
            List<CompletedTask> completedTasks = snapshot.data!;
            return ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                CompletedTask completedTask = completedTasks[index];
                return ListTile(
                  title: Text(completedTask.title),
                  subtitle: RichText(
                    text: TextSpan(
                      text: 'Pesan: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: completedTask.message,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(completedTask.message);
                            },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membuka URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
