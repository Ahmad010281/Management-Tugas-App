import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';
import '../models/completed_task.dart';

class TaskController {
  List<Task> tasks = [];
  Dio dio = Dio();

  TaskController() {
    dio.options.baseUrl =
        'https://64a2391db45881cc0ae4e4c1.mockapi.io'; // Ganti dengan URL API Anda
  }

  Future<void> saveTasksToLocal(List<Task> tasks) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> taskStrings =
          tasks.map((task) => task.toJsonString()).toList();
      await prefs.setStringList('tasks', taskStrings);
    } catch (error) {
      print('Failed to save tasks to local storage. Error: $error');
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      Response response = await dio.post('/tasks', data: task.toJson());

      if (response.statusCode == 201) {
        Task addedTask = Task.fromJson(response.data);
        tasks.add(addedTask);
        await saveTasksToLocal(tasks); // Simpan data ke penyimpanan lokal
        return true; // Task berhasil ditambahkan
      } else {
        print(
            'Failed to add task. Error: ${response.statusCode}, ${response.data}');
        return false; // Gagal menambahkan task
      }
    } catch (error) {
      print('Failed to add task. Error: $error');
      return false; // Gagal menambahkan task
    }
  }

  Future<List<Task>> getTasksFromLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? taskStrings = prefs.getStringList('tasks');

      if (taskStrings != null) {
        return taskStrings
            .map((taskString) => Task.fromJsonString(taskString))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print('Failed to get tasks from local storage. Error: $error');
      return [];
    }
  }

  Future<List<Task>> fetchTasks() async {
    try {
      List<Task> fetchedTasks = await getTasksFromLocal();

      if (fetchedTasks.isEmpty) {
        Response response = await dio.get('/tasks');

        if (response.statusCode == 200) {
          fetchedTasks =
              List<Task>.from(response.data.map((task) => Task.fromJson(task)));

          await saveTasksToLocal(fetchedTasks);
        } else {
          print(
              'Failed to fetch tasks from API. Error: ${response.statusCode}');
          throw Exception('Failed to fetch tasks from API');
        }
      }

      tasks.clear();
      tasks.addAll(fetchedTasks);

      return fetchedTasks;
    } catch (error) {
      print('Failed to fetch tasks. Error: $error');
      throw Exception('Failed to fetch tasks');
    }
  }

  Task getTaskById(String taskId) {
    return tasks.firstWhere((task) => task.id == taskId);
  }

  void updateTask(String taskId, Task updatedTask) async {
    try {
      Response response =
          await dio.put('/tasks/$taskId', data: updatedTask.toJson());

      if (response.statusCode == 200) {
        // Tugas berhasil diperbarui
        Task updatedTaskResponse = Task.fromJson(response.data);
        int index = tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          tasks[index] = updatedTaskResponse;
          await saveTasksToLocal(
              tasks); // Simpan data tugas ke penyimpanan lokal
        }
      } else {
        // Respons tidak sukses, tampilkan pesan error
        print('Failed to update task. Error: ${response.statusCode}');
      }
    } catch (error) {
      // Penanganan kesalahan jaringan atau kesalahan lainnya
      print('Failed to update task. Error: $error');
    }
  }

  void deleteTask(String taskId) async {
    try {
      Response response = await dio.delete('/tasks/$taskId');

      if (response.statusCode == 200) {
        tasks.removeWhere((task) => task.id == taskId);
        await saveTasksToLocal(tasks); // Simpan data tugas ke penyimpanan lokal
      } else {
        print('Failed to delete task. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete task. Error: $error');
    }
  }

  Future<bool> completeTask(Task task, String message) async {
    try {
      Response response = await dio.post('/completed-tasks', data: {
        'taskId': task.id,
        'message': message,
        'date': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 201) {
        // Tugas selesai berhasil ditambahkan
        // Tambahkan logika lain yang diperlukan
        return true;
      } else {
        print('Failed to complete task. Error: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Failed to complete task. Error: $error');
      return false;
    }
  }

// Di dalam TaskController atau widget yang mengonsumsi API
  Future<List<CompletedTask>> fetchCompletedTasks() async {
    try {
      Response response = await dio.get('/completed-tasks');

      if (response.statusCode == 200) {
        List<CompletedTask> completedTasks = List<CompletedTask>.from(
          response.data.map((task) {
            CompletedTask completedTask = CompletedTask.fromJson(task);

            // Mengambil title dari tabel tasks menggunakan ID tasksId
            Task originalTask = getTaskById(completedTask.taskId);
            completedTask.title = originalTask.title;

            return completedTask;
          }),
        );

        return completedTasks;
      } else {
        print(
          'Failed to fetch completed tasks from API. Error: ${response.statusCode}',
        );
        throw Exception('Failed to fetch completed tasks from API');
      }
    } catch (error) {
      print('Failed to fetch completed tasks. Error: $error');
      throw Exception('Failed to fetch completed tasks');
    }
  }
}
