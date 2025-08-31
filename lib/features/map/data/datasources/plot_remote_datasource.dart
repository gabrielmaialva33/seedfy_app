import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart' as core_exceptions;
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/planting.dart';
import '../../../../shared/domain/entities/plot.dart';

abstract class PlotRemoteDataSource {
  Future<List<Plot>> getFarmPlots(String farmId);

  Future<Plot> getPlot(String plotId);

  Future<Plot> createPlot(Plot plot);

  Future<Plot> updatePlot(Plot plot);

  Future<void> deletePlot(String plotId);

  Future<List<Bed>> getPlotBeds(String plotId);

  Future<Bed> createBed(Bed bed);

  Future<Bed> updateBed(Bed bed);

  Future<void> deleteBed(String bedId);

  Future<List<Planting>> getBedPlantings(String bedId);
}

class PlotRemoteDataSourceImpl implements PlotRemoteDataSource {
  final SupabaseClient supabaseClient;

  const PlotRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Plot>> getFarmPlots(String farmId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null)
        throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient
          .from('plots')
          .select('''
            *,
            farms!inner(owner_id)
          ''')
          .eq('farm_id', farmId)
          .eq('farms.owner_id', user.id)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Plot.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<Plot> getPlot(String plotId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null)
        throw const core_exceptions.AuthException('User not authenticated');

      final response = await supabaseClient.from('plots').select('''
            *,
            farms!inner(owner_id)
          ''').eq('id', plotId).eq('farms.owner_id', user.id).single();

      return Plot.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<Plot> createPlot(Plot plot) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null)
        throw const core_exceptions.AuthException('User not authenticated');

      final plotData = plot.toJson();
      plotData.remove('id');

      final response =
          await supabaseClient.from('plots').insert(plotData).select().single();

      return Plot.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<Plot> updatePlot(Plot plot) async {
    try {
      final response = await supabaseClient
          .from('plots')
          .update(plot.toJson())
          .eq('id', plot.id)
          .select()
          .single();

      return Plot.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<void> deletePlot(String plotId) async {
    try {
      await supabaseClient.from('plots').delete().eq('id', plotId);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<List<Bed>> getPlotBeds(String plotId) async {
    try {
      final response = await supabaseClient
          .from('beds')
          .select()
          .eq('plot_id', plotId)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Bed.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<Bed> createBed(Bed bed) async {
    try {
      final bedData = bed.toJson();
      bedData.remove('id');

      final response =
          await supabaseClient.from('beds').insert(bedData).select().single();

      return Bed.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<Bed> updateBed(Bed bed) async {
    try {
      final response = await supabaseClient
          .from('beds')
          .update(bed.toJson())
          .eq('id', bed.id)
          .select()
          .single();

      return Bed.fromJson(response);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<void> deleteBed(String bedId) async {
    try {
      await supabaseClient.from('beds').delete().eq('id', bedId);
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }

  @override
  Future<List<Planting>> getBedPlantings(String bedId) async {
    try {
      final response = await supabaseClient.from('plantings').select('''
            *,
            crops_catalog(*)
          ''').eq('bed_id', bedId).order('sowing_date', ascending: false);

      return (response as List<dynamic>)
          .map((json) => Planting.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw core_exceptions.ServerException(e.message);
    }
  }
}
