import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'screens/task_list_screen.dart';
import 'models/task_model.dart';
import 'services/hive_service.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  final taskBox = await Hive.openBox<Task>('tasks');

  runApp(TaskManagementApp(taskBox: taskBox));
}

class TaskManagementApp extends StatelessWidget {
  final Box<Task> taskBox;

  const TaskManagementApp({super.key, required this.taskBox});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(TaskController(hiveService: HiveService(taskBox: taskBox)));
      }),
      home: const TaskListScreen(),
    );
  }
}
