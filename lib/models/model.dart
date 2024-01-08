import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Task.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Task.fromJson(jsonMap);
  }
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
  Task.optional({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
