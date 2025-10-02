class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.name,
      'category': category.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: TaskPriority.values.firstWhere((e) => e.name == json['priority']),
      category: TaskCategory.values.firstWhere((e) => e.name == json['category']),
      status: TaskStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  bool get isOverdue => status != TaskStatus.completed && dueDate.isBefore(DateTime.now());
  bool get isDueToday => !isOverdue && dueDate.day == DateTime.now().day && 
                        dueDate.month == DateTime.now().month && 
                        dueDate.year == DateTime.now().year;
  bool get isDueTomorrow => dueDate.day == DateTime.now().add(const Duration(days: 1)).day && 
                           dueDate.month == DateTime.now().add(const Duration(days: 1)).month && 
                           dueDate.year == DateTime.now().add(const Duration(days: 1)).year;
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}

enum TaskCategory {
  watering,
  fertilizing,
  planting,
  harvesting,
  pestControl,
  maintenance,
  planning,
  other;

  String get displayName {
    switch (this) {
      case TaskCategory.watering:
        return 'Watering';
      case TaskCategory.fertilizing:
        return 'Fertilizing';
      case TaskCategory.planting:
        return 'Planting';
      case TaskCategory.harvesting:
        return 'Harvesting';
      case TaskCategory.pestControl:
        return 'Pest Control';
      case TaskCategory.maintenance:
        return 'Maintenance';
      case TaskCategory.planning:
        return 'Planning';
      case TaskCategory.other:
        return 'Other';
    }
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}
