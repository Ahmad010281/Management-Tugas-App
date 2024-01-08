import 'package:flutter/material.dart';
import 'package:flutter_uji_coba/controllers/controller.dart';
import 'package:flutter_uji_coba/models/completed_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

class AdminCompletedTaskListView extends StatelessWidget {
  final TaskController taskController;

  AdminCompletedTaskListView({required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Dikerjakan (Admin)'),
      ),
      body: FutureBuilder<List<CompletedTask>>(
        future: taskController.fetchCompletedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Tidak ada tugas yang telah dikerjakan.'));
          } else {
            List<CompletedTask> completedTasks = snapshot.data!;
            return ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                CompletedTask completedTask = completedTasks[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToCompletedTaskDetail(context, completedTask);
                  },
                  child: ListTile(
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToCompletedTaskDetail(
      BuildContext context, CompletedTask completedTask) {
    // Implementasi navigasi ke halaman detail tugas yang telah dikerjakan
    // Sesuaikan dengan halaman yang sesuai
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminCompletedTaskDetailView(
          taskController: taskController,
          completedTask: completedTask,
        ),
      ),
    );
  }
}

class AdminCompletedTaskDetailView extends StatelessWidget {
  final TaskController taskController;
  final CompletedTask completedTask;

  AdminCompletedTaskDetailView(
      {required this.taskController, required this.completedTask});

  @override
  Widget build(BuildContext context) {
    // Implementasi tampilan halaman detail tugas yang telah dikerjakan
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas Dikerjakan (Admin)'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completedTask.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Pesan: ${completedTask.message}'),
          // Tambahkan widget atau tampilan sesuai kebutuhan
          // Contoh: Text('Tanggal: ${completedTask.date.toString()}'),
        ],
      ),
    );
  }
}
