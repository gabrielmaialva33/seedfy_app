import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart' as core_exceptions;
import '../../../../shared/domain/entities/farm.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/planting.dart';

abstract class FarmRemoteDataSource {
  Future<List<Farm>> getUserFarms();
  Future<Farm> getFarm(String farmId);
  Future<Farm> createFarm(Farm farm);
  Future<Farm> updateFarm(Farm farm);
  Future<void> deleteFarm(String farmId);
  Future<List<Plot>> getFarmPlots(String farmId);
  Future<List<Bed>> getFarmBeds(String farmId);
  Future<List<Planting>> getFarmPlantings(String farmId);
  Future<Map<String, dynamic>> getFarmStats(String farmId);
}

class FarmRemoteDataSourceImpl implements FarmRemoteDataSource {
  final SupabaseClient supabaseClient;

  const FarmRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Farm>> getUserFarms() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('farms')
          .select()
          .eq('owner_id', user.id)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => Farm.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get user farms: ${e.toString()}');
    }
  }

  @override
  Future<Farm> getFarm(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('farms')
          .select()
          .eq('id', farmId)
          .eq('owner_id', user.id)
          .single();

      return Farm.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get farm: ${e.toString()}');
    }
  }

  @override
  Future<Farm> createFarm(Farm farm) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final farmData = farm.toJson();
      farmData['owner_id'] = user.id;
      farmData.remove('id'); // Let database generate ID

      final response = await supabaseClient
          .from('farms')
          .insert(farmData)
          .select()
          .single();

      return Farm.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to create farm: ${e.toString()}');
    }
  }

  @override
  Future<Farm> updateFarm(Farm farm) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('farms')
          .update(farm.toJson())
          .eq('id', farm.id)
          .eq('owner_id', user.id)
          .select()
          .single();

      return Farm.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to update farm: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFarm(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      await supabaseClient
          .from('farms')
          .delete()
          .eq('id', farmId)
          .eq('owner_id', user.id);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to delete farm: ${e.toString()}');
    }
  }

  @override
  Future<List<Plot>> getFarmPlots(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('plots')
          .select()
          .eq('farm_id', farmId)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Plot.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get farm plots: ${e.toString()}');
    }
  }

  @override
  Future<List<Bed>> getFarmBeds(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('beds')
          .select('''
            *,
            plots!inner(farm_id)
          ''')
          .eq('plots.farm_id', farmId)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Bed.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get farm beds: ${e.toString()}');
    }
  }

  @override
  Future<List<Planting>> getFarmPlantings(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('plantings')
          .select('''
            *,
            beds!inner(
              plot_id,
              plots!inner(farm_id)
            ),
            crops_catalog(*)
          ''')
          .eq('beds.plots.farm_id', farmId)
          .eq('status', 'growing')
          .order('sowing_date', ascending: false);

      return (response as List<dynamic>)
          .map((json) => Planting.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get farm plantings: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getFarmStats(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw const core_exceptions.AuthException('User not authenticated');

      // Get stats using database functions or aggregations
      final plotsCount = await supabaseClient
          .from('plots')
          .select('id', const FetchOptions(count: CountOption.exact))
          .eq('farm_id', farmId);

      final bedsCount = await supabaseClient
          .from('beds')
          .select('''
            id,
            plots!inner(farm_id)
          ''', const FetchOptions(count: CountOption.exact))
          .eq('plots.farm_id', farmId);

      final activePlantings = await supabaseClient
          .from('plantings')
          .select('''
            id,
            beds!inner(
              plot_id,
              plots!inner(farm_id)
            )
          ''', const FetchOptions(count: CountOption.exact))
          .eq('beds.plots.farm_id', farmId)
          .eq('status', 'growing');

      final pendingTasks = await supabaseClient
          .from('tasks')
          .select('''
            id,
            plantings!inner(
              bed_id,
              beds!inner(
                plot_id,
                plots!inner(farm_id)
              )
            )
          ''', const FetchOptions(count: CountOption.exact))
          .eq('plantings.beds.plots.farm_id', farmId)
          .eq('done', false);

      return {
        'plots_count': plotsCount.count ?? 0,
        'beds_count': bedsCount.count ?? 0,
        'active_plantings': activePlantings.count ?? 0,
        'pending_tasks': pendingTasks.count ?? 0,
      };
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get farm stats: ${e.toString()}');
    }
  }
}