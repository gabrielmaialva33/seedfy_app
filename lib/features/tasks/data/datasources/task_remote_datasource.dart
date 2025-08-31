import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart' as core_exceptions;
import '../../../../shared/domain/entities/task.dart' as entities;

abstract class TaskRemoteDataSource {
  Future<List<entities.Task>> getUserTasks();

  Future<List<entities.Task>> getFarmTasks(String farmId);

  Future<List<entities.Task>> getPlantingTasks(String plantingId);

  Future<List<entities.Task>> getPendingTasks();

  Future<List<entities.Task>> getTodayTasks();

  Future<List<entities.Task>> getOverdueTasks();

  Future<entities.Task> createTask(entities.Task task);

  Future<entities.Task> updateTask(entities.Task task);

  Future<entities.Task> completeTask(String taskId, {String? notes, int? actualMinutes});

  Future<void> deleteTask(String taskId);

  Future<Map<String, dynamic>> getTaskStats();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient supabaseClient;

  const TaskRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<entities.Task>> getUserTasks() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get user tasks: ${e.toString()}');
    }
  }

  @override
  Future<List<entities.Task>> getFarmTasks(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(id, owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.id', farmId)
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get farm tasks: ${e.toString()}');
    }
  }

  @override
  Future<List<entities.Task>> getPlantingTasks(String plantingId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('planting_id', plantingId)
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get planting tasks: ${e.toString()}');
    }
  }

  @override
  Future<List<entities.Task>> getPendingTasks() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .eq('done', false)
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get pending tasks: ${e.toString()}');
    }
  }

  @override
  Future<List<entities.Task>> getTodayTasks() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .gte('due_date', todayStart.toIso8601String())
          .lt('due_date', todayEnd.toIso8601String())
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get today tasks: ${e.toString()}');
    }
  }

  @override
  Future<List<entities.Task>> getOverdueTasks() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final now = DateTime.now();

      final response = await supabaseClient
          .from('tasks')
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .eq('done', false)
          .lt('due_date', now.toIso8601String())
          .order('due_date', ascending: true);

      return (response as List<dynamic>)
          .map((json) => entities.Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get overdue tasks: ${e.toString()}');
    }
  }

  @override
  Future<entities.Task> createTask(entities.Task task) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final taskData = task.toJson();
      taskData.remove('id'); // Let database generate ID

      final response =
          await supabaseClient.from('tasks').insert(taskData).select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''').single();

      return entities.Task.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to create task: ${e.toString()}');
    }
  }

  @override
  Future<entities.Task> updateTask(entities.Task task) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('tasks')
          .update(task.toJson())
          .eq('id', task.id)
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''').single();

      return entities.Task.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to update task: ${e.toString()}');
    }
  }

  @override
  Future<entities.Task> completeTask(String taskId,
      {String? notes, int? actualMinutes}) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final updateData = {
        'done': true,
        'completed_at': DateTime.now().toIso8601String(),
        'completed_by': user.id,
      };

      if (notes != null) updateData['notes'] = notes;
      if (actualMinutes != null) updateData['actual_minutes'] = actualMinutes;

      final response = await supabaseClient
          .from('tasks')
          .update(updateData)
          .eq('id', taskId)
          .select('''
            *,
            plantings!inner(
              *,
              beds!inner(
                *,
                plots!inner(
                  *,
                  farms!inner(owner_id)
                )
              ),
              crops_catalog(*)
            )
          ''').single();

      return entities.Task.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to complete task: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      await supabaseClient.from('tasks').delete().eq('id', taskId);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to delete task: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getTaskStats() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw core_exceptions.AuthException('User not authenticated');
      }

      final totalTasks = await supabaseClient
          .from('tasks')
          .select('''
            id,
            plantings!inner(
              beds!inner(
                plots!inner(
                  farms!inner(owner_id)
                )
              )
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .count(CountOption.exact);

      final completedTasks = await supabaseClient
          .from('tasks')
          .select('''
            id,
            plantings!inner(
              beds!inner(
                plots!inner(
                  farms!inner(owner_id)
                )
              )
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .eq('done', true)
          .count(CountOption.exact);

      final pendingTasks = await supabaseClient
          .from('tasks')
          .select('''
            id,
            plantings!inner(
              beds!inner(
                plots!inner(
                  farms!inner(owner_id)
                )
              )
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .eq('done', false)
          .count(CountOption.exact);

      final overdueTasks = await supabaseClient
          .from('tasks')
          .select('''
            id,
            plantings!inner(
              beds!inner(
                plots!inner(
                  farms!inner(owner_id)
                )
              )
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', user.id)
          .eq('done', false)
          .lt('due_date', DateTime.now().toIso8601String())
          .count(CountOption.exact);

      return {
        'total_tasks': totalTasks.count,
        'completed_tasks': completedTasks.count,
        'pending_tasks': pendingTasks.count,
        'overdue_tasks': overdueTasks.count,
        'completion_rate': totalTasks.count > 0
            ? (completedTasks.count / totalTasks.count * 100)
                .round()
            : 0,
      };
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw core_exceptions.ServerException(
          'Failed to get task stats: ${e.toString()}');
    }
  }
}
