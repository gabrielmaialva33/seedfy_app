import 'package:flutter_test/flutter_test.dart';
import 'package:seedfy_app/shared/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    late Task task;

    setUp(() {
      task = Task(
        id: 'test-task-123',
        plantingId: 'test-planting-456',
        title: 'Water tomatoes',
        description: 'Water the tomato plants in bed A1',
        type: TaskType.water,
        status: TaskStatus.pending,
        dueDate: DateTime(2023, 12, 25),
        done: false,
        createdAt: DateTime(2023, 12, 20),
      );
    });

    test('should create a task with valid properties', () {
      expect(task.id, 'test-task-123');
      expect(task.plantingId, 'test-planting-456');
      expect(task.title, 'Water tomatoes');
      expect(task.description, 'Water the tomato plants in bed A1');
      expect(task.type, TaskType.water);
      expect(task.status, TaskStatus.pending);
      expect(task.done, false);
      expect(task.dueDate, DateTime(2023, 12, 25));
      expect(task.createdAt, DateTime(2023, 12, 20));
    });

    test('getTypeKey should return correct string for task types', () {
      expect(task.getTypeKey(), 'water');

      final fertilizeTask = task.copyWith(type: TaskType.fertilize);
      expect(fertilizeTask.getTypeKey(), 'fertilize');

      final transplantTask = task.copyWith(type: TaskType.transplant);
      expect(transplantTask.getTypeKey(), 'transplant');

      final harvestTask = task.copyWith(type: TaskType.harvest);
      expect(harvestTask.getTypeKey(), 'harvest');

      final weedTask = task.copyWith(type: TaskType.weed);
      expect(weedTask.getTypeKey(), 'weed');

      final pruneTask = task.copyWith(type: TaskType.prune);
      expect(pruneTask.getTypeKey(), 'prune');

      final monitorTask = task.copyWith(type: TaskType.monitor);
      expect(monitorTask.getTypeKey(), 'monitor');

      final otherTask = task.copyWith(type: TaskType.other);
      expect(otherTask.getTypeKey(), 'other');
    });

    test('getStatusKey should return correct string for task status', () {
      expect(task.getStatusKey(), 'pending');

      final growingTask = task.copyWith(status: TaskStatus.growing);
      expect(growingTask.getStatusKey(), 'growing');

      final completedTask = task.copyWith(status: TaskStatus.completed);
      expect(completedTask.getStatusKey(), 'completed');

      final canceledTask = task.copyWith(status: TaskStatus.canceled);
      expect(canceledTask.getStatusKey(), 'canceled');
    });

    test('copyWith should create a new task with updated properties', () {
      final updatedTask = task.copyWith(
        title: 'Water and fertilize tomatoes',
        done: true,
        status: TaskStatus.completed,
        completedAt: DateTime(2023, 12, 24),
      );

      expect(updatedTask.id, task.id); // unchanged
      expect(updatedTask.plantingId, task.plantingId); // unchanged
      expect(updatedTask.title, 'Water and fertilize tomatoes'); // changed
      expect(updatedTask.done, true); // changed
      expect(updatedTask.status, TaskStatus.completed); // changed
      expect(updatedTask.completedAt, DateTime(2023, 12, 24)); // changed
      expect(updatedTask.type, task.type); // unchanged
    });

    test('fromJson should create task from valid JSON', () {
      final json = {
        'id': 'json-task-123',
        'planting_id': 'json-planting-456',
        'title': 'Harvest lettuce',
        'description': 'Harvest mature lettuce leaves',
        'type': 'harvest',
        'status': 'completed',
        'due_date': '2023-12-25T00:00:00.000Z',
        'sowing_date': '2023-11-01T00:00:00.000Z',
        'harvest_date': '2023-12-25T00:00:00.000Z',
        'done': true,
        'completed_at': '2023-12-24T10:30:00.000Z',
        'completed_by': 'user-789',
        'notes': 'Harvested 500g of lettuce',
        'estimated_minutes': 30,
        'actual_minutes': 25,
        'created_at': '2023-11-01T00:00:00.000Z',
        'updated_at': '2023-12-24T10:30:00.000Z',
      };

      final taskFromJson = Task.fromJson(json);

      expect(taskFromJson.id, 'json-task-123');
      expect(taskFromJson.plantingId, 'json-planting-456');
      expect(taskFromJson.title, 'Harvest lettuce');
      expect(taskFromJson.description, 'Harvest mature lettuce leaves');
      expect(taskFromJson.type, TaskType.harvest);
      expect(taskFromJson.status, TaskStatus.completed);
      expect(taskFromJson.done, true);
      expect(taskFromJson.completedBy, 'user-789');
      expect(taskFromJson.notes, 'Harvested 500g of lettuce');
      expect(taskFromJson.estimatedMinutes, 30);
      expect(taskFromJson.actualMinutes, 25);
    });

    test('fromJson should handle Portuguese task types', () {
      final json = {
        'id': 'pt-task-123',
        'planting_id': 'pt-planting-456',
        'title': 'Regar tomates',
        'type': 'regar',
        'status': 'pending',
        'due_date': '2023-12-25T00:00:00.000Z',
        'done': false,
        'created_at': '2023-12-20T00:00:00.000Z',
      };

      final taskFromJson = Task.fromJson(json);
      expect(taskFromJson.type, TaskType.water);
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 'minimal-task-123',
        'planting_id': 'minimal-planting-456',
        'title': 'Minimal task',
        'type': 'other',
        'status': 'pending',
        'due_date': '2023-12-25T00:00:00.000Z',
        'done': false,
        'created_at': '2023-12-20T00:00:00.000Z',
      };

      final taskFromJson = Task.fromJson(json);

      expect(taskFromJson.description, null);
      expect(taskFromJson.sowingDate, null);
      expect(taskFromJson.harvestDate, null);
      expect(taskFromJson.completedAt, null);
      expect(taskFromJson.completedBy, null);
      expect(taskFromJson.notes, null);
      expect(taskFromJson.estimatedMinutes, null);
      expect(taskFromJson.actualMinutes, null);
      expect(taskFromJson.updatedAt, null);
    });

    test('toJson should convert task to JSON correctly', () {
      final taskWithAllFields = Task(
        id: 'full-task-123',
        plantingId: 'full-planting-456',
        title: 'Complete task',
        description: 'A complete task with all fields',
        type: TaskType.fertilize,
        status: TaskStatus.completed,
        dueDate: DateTime(2023, 12, 25),
        sowingDate: DateTime(2023, 11, 1),
        harvestDate: DateTime(2023, 12, 30),
        done: true,
        completedAt: DateTime(2023, 12, 24),
        completedBy: 'user-789',
        notes: 'Task completed successfully',
        estimatedMinutes: 45,
        actualMinutes: 40,
        createdAt: DateTime(2023, 11, 1),
        updatedAt: DateTime(2023, 12, 24),
      );

      final json = taskWithAllFields.toJson();

      expect(json['id'], 'full-task-123');
      expect(json['planting_id'], 'full-planting-456');
      expect(json['title'], 'Complete task');
      expect(json['description'], 'A complete task with all fields');
      expect(json['type'], 'fertilize');
      expect(json['status'], 'completed');
      expect(json['done'], true);
      expect(json['completed_by'], 'user-789');
      expect(json['notes'], 'Task completed successfully');
      expect(json['estimated_minutes'], 45);
      expect(json['actual_minutes'], 40);
      expect(json['due_date'], '2023-12-25T00:00:00.000');
      expect(json['sowing_date'], '2023-11-01T00:00:00.000');
      expect(json['harvest_date'], '2023-12-30T00:00:00.000');
      expect(json['completed_at'], '2023-12-24T00:00:00.000');
      expect(json['created_at'], '2023-11-01T00:00:00.000');
      expect(json['updated_at'], '2023-12-24T00:00:00.000');
    });

    test('toJson should handle null optional fields', () {
      final taskWithNulls = Task(
        id: 'test-task-123',
        plantingId: 'test-planting-456',
        title: 'Water tomatoes',
        type: TaskType.water,
        status: TaskStatus.pending,
        dueDate: DateTime(2023, 12, 25),
        done: false,
        createdAt: DateTime(2023, 12, 20),
      );

      final json = taskWithNulls.toJson();

      expect(json['description'], null);
      expect(json['sowing_date'], null);
      expect(json['harvest_date'], null);
      expect(json['completed_at'], null);
      expect(json['completed_by'], null);
      expect(json['notes'], null);
      expect(json['estimated_minutes'], null);
      expect(json['actual_minutes'], null);
      expect(json['updated_at'], null);
    });
  });
}
