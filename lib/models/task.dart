enum TaskType {
  water,
  fertilize,
  transplant,
  harvest,
}

class GardenTask {
  final String id;
  final String plantingId;
  final TaskType type;
  final DateTime dueDate;
  final bool done;
  final DateTime createdAt;

  const GardenTask({
    required this.id,
    required this.plantingId,
    required this.type,
    required this.dueDate,
    required this.done,
    required this.createdAt,
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
    }
  }

  factory GardenTask.fromJson(Map<String, dynamic> json) {
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
      default:
        type = TaskType.water;
    }

    return GardenTask(
      id: json['id'],
      plantingId: json['planting_id'],
      type: type,
      dueDate: DateTime.parse(json['due_date']),
      done: json['done'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planting_id': plantingId,
      'type': getTypeKey(),
      'due_date': dueDate.toIso8601String().split('T')[0],
      'done': done,
      'created_at': createdAt.toIso8601String(),
    };
  }
}