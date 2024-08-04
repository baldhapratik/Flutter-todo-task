import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller/task_controller.dart';
import '../models/task_model.dart';
import 'task_form_screen.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController taskController = Get.find();

  @override
  void initState() {
    super.initState();
    taskController.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              taskController.filterTasksByStatus(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'To Do', child: Text('To Do')),
              const PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'Done', child: Text('Done')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (taskController.filteredTasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: taskController.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = taskController.filteredTasks[index];

            return TaskItem(
              task: task,
              onDelete: () {
                taskController.deleteTask(task);
              },
              onUpdate: (updatedTask) {
                taskController.updateTask(updatedTask);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to<Task>(const TaskFormScreen());

          if (result != null) {
            taskController.addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
