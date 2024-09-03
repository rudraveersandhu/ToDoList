import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/services/notification_services.dart';
import 'package:todo_list/views/homeView.dart';
import 'models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await Hive.openBox<Task>('tasksBox');

  await NotificationService.init();

  runApp(MyApp());

  NotificationService.scheduleNotification(
    id: 0,
    title: "Test Notification",
    body: "This is a test notification to check if notifications are working.",
    scheduledDate: tz.TZDateTime.now( tz.getLocation('Asia/Kolkata')).add(const Duration(seconds: 5)),
  );
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDoList App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}
