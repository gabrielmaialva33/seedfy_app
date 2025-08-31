enum TaskType {
  water,
  fertilize,
  transplant,
  harvest,
  weed,
  prune,
  monitor,
  other,
}

enum TaskStatus {
  pending,
  growing,
  completed,
  canceled,
}

class Task {
  final String id;
  final String plantingId;
  final String title;
  final String? description;
  final TaskType type;
  final TaskStatus status;
  final DateTime dueDate;
  final DateTime? sowingDate;
  final DateTime? harvestDate;
  final bool done;
  final DateTime? completedAt;
  final String? completedBy;
  final String? notes;
  final int? estimatedMinutes;
  final int? actualMinutes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.plantingId,
    required this.title,
    this.description,
    required this.type,
    required this.status,
    required this.dueDate,
    this.sowingDate,
    this.harvestDate,
    required this.done,
    this.completedAt,
    this.completedBy,
    this.notes,
    this.estimatedMinutes,
    this.actualMinutes,
    required this.createdAt,
    this.updatedAt,
  });

  String getTypeKey() {
    switch (type) {
      case TaskType.water:
        return 'water';
      case TaskType.fertilize:
        return 'fertilize';
      case TaskType.transplant:
        return 'transplant';
      case TaskType.harvest:
        return 'harvest';
      case TaskType.weed:
        return 'weed';
      case TaskType.prune:
        return 'prune';
      case TaskType.monitor:
        return 'monitor';
      case TaskType.other:
        return 'other';
    }
  }

  String getStatusKey() {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.growing:
        return 'growing';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.canceled:
        return 'canceled';
    }
  }

  Task copyWith({
    String? id,
    String? plantingId,
    String? title,
    String? description,
    TaskType? type,
    TaskStatus? status,
    DateTime? dueDate,
    DateTime? sowingDate,
    DateTime? harvestDate,
    bool? done,
    DateTime? completedAt,
    String? completedBy,
    String? notes,
    int? estimatedMinutes,
    int? actualMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      plantingId: plantingId ?? this.plantingId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      sowingDate: sowingDate ?? this.sowingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      done: done ?? this.done,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
      notes: notes ?? this.notes,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    TaskType type;
    switch (json['type']) {
      case 'regar':
      case 'water':
        type = TaskType.water;
        break;
      case 'adubar':
      case 'fertilize':
        type = TaskType.fertilize;
        break;
      case 'transplantar':
      case 'transplant':
        type = TaskType.transplant;
        break;
      case 'colher':
      case 'harvest':
        type = TaskType.harvest;
        break;
      case 'weed':
        type = TaskType.weed;
        break;
      case 'prune':
        type = TaskType.prune;
        break;
      case 'monitor':
        type = TaskType.monitor;
        break;
      default:
        type = TaskType.other;
    }

    TaskStatus status;
    switch (json['status']) {
      case 'pending':
        status = TaskStatus.pending;
        break;
      case 'growing':
        status = TaskStatus.growing;
        break;
      case 'completed':
        status = TaskStatus.completed;
        break;
      case 'canceled':
        status = TaskStatus.canceled;
        break;
      default:
        status = TaskStatus.pending;
    }

    return Task(
      id: json['id'] ?? '',
      plantingId: json['planting_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: type,
      status: status,
      dueDate:
          DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      sowingDate: json['sowing_date'] != null
          ? DateTime.parse(json['sowing_date'])
          : null,
      harvestDate: json['harvest_date'] != null
          ? DateTime.parse(json['harvest_date'])
          : null,
      done: json['done'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      completedBy: json['completed_by'],
      notes: json['notes'],
      estimatedMinutes: json['estimated_minutes'],
      actualMinutes: json['actual_minutes'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planting_id': plantingId,
      'title': title,
      'description': description,
      'type': getTypeKey(),
      'status': getStatusKey(),
      'due_date': dueDate.toIso8601String(),
      'sowing_date': sowingDate?.toIso8601String(),
      'harvest_date': harvestDate?.toIso8601String(),
      'done': done,
      'completed_at': completedAt?.toIso8601String(),
      'completed_by': completedBy,
      'notes': notes,
      'estimated_minutes': estimatedMinutes,
      'actual_minutes': actualMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// Legacy class for backward compatibility
typedef GardenTask = Task;
