import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get pendingTasks => _tasks.where((task) => task.status == TaskStatus.pending).toList();
  List<Task> get inProgressTasks => _tasks.where((task) => task.status == TaskStatus.inProgress).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.status == TaskStatus.completed).toList();
  List<Task> get overdueTasks => _tasks.where((task) => task.isOverdue).toList();
  List<Task> get todayTasks => _tasks.where((task) => task.isDueToday).toList();
  List<Task> get tomorrowTasks => _tasks.where((task) => task.isDueTomorrow).toList();

  TaskProvider() {
    _loadDemoTasks();
  }

  void _loadDemoTasks() {
    final now = DateTime.now();
    _tasks = [
      Task(
        id: '1',
        title: 'Water tomato field',
        description: 'Water the main tomato field in section A. Check soil moisture levels first.',
        dueDate: DateTime(now.year, now.month, now.day, 6, 0),
        priority: TaskPriority.urgent,
        category: TaskCategory.watering,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: '2',
        title: 'Apply fertilizer to corn',
        description: 'Apply organic fertilizer to the corn crop in the north field.',
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.high,
        category: TaskCategory.fertilizing,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: '3',
        title: 'Harvest lettuce',
        description: 'Harvest mature lettuce from greenhouse 2. Check for optimal freshness.',
        dueDate: now.add(const Duration(days: 3)),
        priority: TaskPriority.medium,
        category: TaskCategory.harvesting,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      Task(
        id: '4',
        title: 'Check pest traps',
        description: 'Inspect and replace pest traps throughout the farm perimeter.',
        dueDate: now.add(const Duration(days: 5)),
        priority: TaskPriority.low,
        category: TaskCategory.pestControl,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      Task(
        id: '5',
        title: 'Repair irrigation system',
        description: 'Fix the broken irrigation pipe in section C.',
        dueDate: now.subtract(const Duration(days: 1)),
        priority: TaskPriority.urgent,
        category: TaskCategory.maintenance,
        status: TaskStatus.completed,
        createdAt: now.subtract(const Duration(days: 3)),
        completedAt: now.subtract(const Duration(hours: 4)),
      ),
    ];
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _tasks.add(task);
    _sortTasks();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _sortTasks();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));

    _tasks.removeWhere((task) => task.id == taskId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final completedTask = task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
    await updateTask(completedTask);
  }

  Future<void> markInProgress(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(status: TaskStatus.inProgress);
    await updateTask(updatedTask);
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      // Sort by priority and due date
      if (a.priority != b.priority) {
        return b.priority.index.compareTo(a.priority.index); // Higher priority first
      }
      return a.dueDate.compareTo(b.dueDate); // Earlier due date first
    });
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Task> getTasksByCategory(TaskCategory category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<Task> getTasksForDateRange(DateTime startDate, DateTime endDate) {
    return _tasks.where((task) =>
        task.dueDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        task.dueDate.isBefore(endDate.add(const Duration(days: 1)))).toList();
  }
}
