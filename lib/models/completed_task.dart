class CompletedTask {
  final String id;
  final String taskId;
  final String message;
  final DateTime date;
  String title; // Tambahkan properti title untuk menunjukkan judul tugas

  CompletedTask({
    required this.id,
    required this.taskId,
    required this.message,
    required this.date,
    required this.title,
  });

  factory CompletedTask.fromJson(Map<String, dynamic> json) {
    return CompletedTask(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      message: json['message'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      title: '', // Sesuaikan dengan nama properti dari API
    );
  }
}
