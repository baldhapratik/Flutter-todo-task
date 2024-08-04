import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/hive_service.dart';

class TaskController extends GetxController {
  final HiveService hiveService;
  var tasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var isLoading = false.obs;

  TaskController({required this.hiveService});

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    isLoading(true);
    tasks.assignAll(hiveService.getTasks());
    filteredTasks.assignAll(tasks);
    isLoading(false);
  }

  void addTask(Task task) {
    hiveService.addTask(task);
    tasks.add(task);
    filterTasksByStatus('All');
  }

  void deleteTask(Task task) {
    hiveService.deleteTask(task);
    tasks.remove(task);
    filterTasksByStatus('All');
  }

  void updateTask(Task updatedTask) {
    int index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index].title = updatedTask.title;
      tasks[index].description = updatedTask.description;
      tasks[index].status = updatedTask.status;
      hiveService.updateTask(tasks[index]);
      filterTasksByStatus('All');
    }
  }

  void filterTasksByStatus(String status) {
    if (status == 'All') {
      filteredTasks.assignAll(tasks);
    } else {
      filteredTasks.assignAll(tasks.where((task) => task.status == status).toList());
    }
  }
}
