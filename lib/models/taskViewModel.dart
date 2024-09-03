import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

import '../services/notification_services.dart';

class TaskViewModel extends GetxController {
  var tasks = <Task>[].obs;
  late Box<Task> tasksBox;


  @override
  void onInit() {
    super.onInit();
    tasksBox = Hive.box<Task>('tasksBox');
    loadTasks();
  }

  void loadTasks() {
    tasks.assignAll(tasksBox.values);
  }

  void addTask(String title, String description, Priority priority, DateTime dueDate) {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );
    tasksBox.put(task.id, task);
    tasks.add(task);


    NotificationService.scheduleNotification(
      id: task.hashCode,
      title: 'Task Reminder',
      body: 'Your task "${task.title}" is due soon.',
      scheduledDate: dueDate.subtract(Duration(hours: 1)), // 1 hour before
    );
  }

  void editTask(String id, String title, String description, Priority priority, DateTime dueDate) {
    final task = tasksBox.get(id);
    if (task != null) {
      task.title = title;
      task.description = description;
      task.priority = priority;
      task.dueDate = dueDate;
      tasksBox.put(id, task);


      int index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        tasks[index] = task;
      }


      NotificationService.cancelNotification(task.hashCode);
      NotificationService.scheduleNotification(
        id: task.hashCode,
        title: 'Task Reminder!',
        body: 'Your task "${task.title}" is due soon.',
        scheduledDate: dueDate.subtract(const Duration(hours: 1)),
      );
    }
  }

  void deleteTask(String id) {
    final task = tasksBox.get(id);
    if (task != null) {
      tasksBox.delete(id);
      tasks.removeWhere((t) => t.id == id);

      NotificationService.cancelNotification(task.hashCode);
    }
  }

  void toggleTaskCompletion(String id) {
    final task = tasksBox.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      tasksBox.put(id, task);

      int index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        tasks[index] = task;
      }
    }
  }


  void sortTasksByPriority() {
    var sorted = tasks.toList()
      ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
    tasks.assignAll(sorted);
  }

  void sortTasksByDueDate() {
    var sorted = tasks.toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    tasks.assignAll(sorted);
  }

  void sortTasksByCreationDate() {
    tasks.assignAll(tasksBox.values.toList());
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      loadTasks();
    } else {
      var filtered = tasksBox.values.where((task) =>
      task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase()));
      tasks.assignAll(filtered);
    }
  }

  void getTasksForDate(DateTime date) {
    var tasksForDate = tasks.where((task) =>
    task.dueDate.year == date.year &&
        task.dueDate.month == date.month &&
        task.dueDate.day == date.day).toList();
    tasks.assignAll(tasksForDate);
  }

}
