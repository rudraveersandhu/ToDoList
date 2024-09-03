import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  Low,
  @HiveField(1)
  Medium,
  @HiveField(2)
  High,
}

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  Priority priority;

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.priority = Priority.Medium,
    required this.dueDate,
    this.isCompleted = false,
  });
}
