import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import '../screens/task_form_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(Task) onUpdate;

  const TaskItem({super.key, required this.task, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: task.status == 'Done'
          ? Colors.greenAccent.shade100
          : task.status == 'In Progress'
              ? Colors.orange.shade100
              : Colors.blueAccent.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        minVerticalPadding: 0,
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<String>(
                value: task.status,
                padding: EdgeInsets.zero,
                isDense: true,
                items: <String>['To Do', 'In Progress', 'Done'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                borderRadius: BorderRadius.circular(10),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    task.status = newValue;
                    onUpdate(task);
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: onDelete,
              child: const Icon(Icons.delete),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                final updatedTask = await Get.to<Task>(TaskFormScreen(task: task));
                if (updatedTask != null) {
                  onUpdate(updatedTask);
                }
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
