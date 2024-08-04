import 'package:hive/hive.dart';
import '../models/task_model.dart';

class HiveService {
  final Box<Task> taskBox;

  HiveService({required this.taskBox});

  List<Task> getTasks() {
    return taskBox.values.toList();
  }

  void addTask(Task task) {
    taskBox.add(task);
  }

  void deleteTask(Task task) {
    task.delete();
  }

  void updateTask(Task task) {
    task.save();
  }
}
