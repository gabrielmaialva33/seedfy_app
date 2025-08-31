import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/bed.dart';
import '../../domain/entities/crop.dart';
import '../../domain/entities/farm.dart';
import '../../domain/entities/planting.dart';
import '../../domain/entities/plot.dart';
import '../../domain/entities/task.dart';
import '../datasources/connectivity_service.dart';
import '../datasources/offline_service.dart';
import '../datasources/supabase_service.dart';
import '../utils/failure.dart';

/// Repository that handles offline-first data management
/// 
/// This repository implements an offline-first strategy where:
/// 1. Reads are served from local cache when available
/// 2. Writes are saved locally and queued for sync
/// 3. Sync happens automatically when connection is available
class OfflineRepository {
  final OfflineService _offlineService;
  final ConnectivityService _connectivityService;
  
  OfflineRepository({
    OfflineService? offlineService,
    ConnectivityService? connectivityService,
  }) : _offlineService = offlineService ?? OfflineService(),
       _connectivityService = connectivityService ?? ConnectivityService() {
    _initializeSync();
  }

  void _initializeSync() {
    // Auto-sync when connection is restored
    _connectivityService.connectionStream.listen((isConnected) {
      if (isConnected) {
        _syncWithServer();
      }
    });
  }

  // Farm operations
  Future<Either<Failure, List<Farm>>> getFarms(String userId) async {
    try {
      // Try local first
      final localFarms = await _offlineService.getFarms();
      
      if (_connectivityService.isConnected) {
        // If connected, try to get fresh data
        try {
          final response = await SupabaseService.client
              .from('farms')
              .select()
              .eq('owner_id', userId);
          
          final remoteFarms = (response as List).map((json) => Farm.fromJson(json)).toList();
          
          // Update local cache
          for (final farm in remoteFarms) {
            await _offlineService.insertFarm(farm);
          }
          
          return Right(remoteFarms);
        } catch (e) {
          debugPrint('Failed to fetch from server, using cache: $e');
        }
      }
      
      return Right(localFarms);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Farm>> createFarm(Farm farm) async {
    try {
      // Always save locally first
      await _offlineService.insertFarm(farm);
      
      if (_connectivityService.isConnected) {
        try {
          // Try to sync immediately
          final response = await SupabaseService.client
              .from('farms')
              .insert(farm.toJson())
              .select()
              .single();
          
          final serverFarm = Farm.fromJson(response);
          
          // Update local cache with server data (including server-generated ID)
          await _offlineService.insertFarm(serverFarm);
          
          return Right(serverFarm);
        } catch (e) {
          debugPrint('Failed to create farm on server, saved locally: $e');
        }
      }
      
      return Right(farm);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Plot operations
  Future<Either<Failure, List<Plot>>> getPlots(String farmId) async {
    try {
      final localPlots = await _offlineService.getPlots(farmId);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('plots')
              .select()
              .eq('farm_id', farmId);
          
          final remotePlots = (response as List).map((json) => Plot.fromJson(json)).toList();
          
          // Update local cache
          for (final plot in remotePlots) {
            await _offlineService.insertPlot(plot);
          }
          
          return Right(remotePlots);
        } catch (e) {
          debugPrint('Failed to fetch plots from server, using cache: $e');
        }
      }
      
      return Right(localPlots);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Plot>> createPlot(Plot plot) async {
    try {
      await _offlineService.insertPlot(plot);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('plots')
              .insert(plot.toJson())
              .select()
              .single();
          
          final serverPlot = Plot.fromJson(response);
          await _offlineService.insertPlot(serverPlot);
          
          return Right(serverPlot);
        } catch (e) {
          debugPrint('Failed to create plot on server, saved locally: $e');
        }
      }
      
      return Right(plot);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Bed operations
  Future<Either<Failure, List<Bed>>> getBeds(String plotId) async {
    try {
      final localBeds = await _offlineService.getBeds(plotId);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('beds')
              .select()
              .eq('plot_id', plotId);
          
          final remoteBeds = (response as List).map((json) => Bed.fromJson(json)).toList();
          
          for (final bed in remoteBeds) {
            await _offlineService.insertBed(bed);
          }
          
          return Right(remoteBeds);
        } catch (e) {
          debugPrint('Failed to fetch beds from server, using cache: $e');
        }
      }
      
      return Right(localBeds);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Bed>> createBed(Bed bed) async {
    try {
      await _offlineService.insertBed(bed);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('beds')
              .insert(bed.toJson())
              .select()
              .single();
          
          final serverBed = Bed.fromJson(response);
          await _offlineService.insertBed(serverBed);
          
          return Right(serverBed);
        } catch (e) {
          debugPrint('Failed to create bed on server, saved locally: $e');
        }
      }
      
      return Right(bed);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Bed>> updateBed(Bed bed) async {
    try {
      await _offlineService.updateBed(bed);
      
      if (_connectivityService.isConnected) {
        try {
          await SupabaseService.client
              .from('beds')
              .update(bed.toJson())
              .eq('id', bed.id);
          
          return Right(bed);
        } catch (e) {
          debugPrint('Failed to update bed on server, saved locally: $e');
        }
      }
      
      return Right(bed);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteBed(String bedId) async {
    try {
      await _offlineService.deleteBed(bedId);
      
      if (_connectivityService.isConnected) {
        try {
          await SupabaseService.client
              .from('beds')
              .delete()
              .eq('id', bedId);
        } catch (e) {
          debugPrint('Failed to delete bed on server, deleted locally: $e');
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Crop operations
  Future<Either<Failure, List<Crop>>> getCrops() async {
    try {
      final localCrops = await _offlineService.getCrops();
      
      // If we have cached crops and we're offline, return them
      if (localCrops.isNotEmpty && !_connectivityService.isConnected) {
        return Right(localCrops);
      }
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('crops_catalog')
              .select()
              .order('name_pt');
          
          final remoteCrops = (response as List).map((json) => Crop.fromJson(json)).toList();
          
          // Cache crops locally
          for (final crop in remoteCrops) {
            await _offlineService.insertCrop(crop);
          }
          
          return Right(remoteCrops);
        } catch (e) {
          debugPrint('Failed to fetch crops from server, using cache: $e');
          return Right(localCrops);
        }
      }
      
      return Right(localCrops);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Planting operations
  Future<Either<Failure, List<Planting>>> getPlantings(String bedId) async {
    try {
      final localPlantings = await _offlineService.getPlantings(bedId);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('plantings')
              .select()
              .eq('bed_id', bedId);
          
          final remotePlantings = (response as List).map((json) => Planting.fromJson(json)).toList();
          
          for (final planting in remotePlantings) {
            await _offlineService.insertPlanting(planting);
          }
          
          return Right(remotePlantings);
        } catch (e) {
          debugPrint('Failed to fetch plantings from server, using cache: $e');
        }
      }
      
      return Right(localPlantings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Planting>> createPlanting(Planting planting) async {
    try {
      await _offlineService.insertPlanting(planting);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('plantings')
              .insert(planting.toJson())
              .select()
              .single();
          
          final serverPlanting = Planting.fromJson(response);
          await _offlineService.insertPlanting(serverPlanting);
          
          return Right(serverPlanting);
        } catch (e) {
          debugPrint('Failed to create planting on server, saved locally: $e');
        }
      }
      
      return Right(planting);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Planting>> updatePlanting(Planting planting) async {
    try {
      await _offlineService.updatePlanting(planting);
      
      if (_connectivityService.isConnected) {
        try {
          await SupabaseService.client
              .from('plantings')
              .update(planting.toJson())
              .eq('id', planting.id);
          
          return Right(planting);
        } catch (e) {
          debugPrint('Failed to update planting on server, saved locally: $e');
        }
      }
      
      return Right(planting);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Task operations
  Future<Either<Failure, List<Task>>> getTasks({String? plantingId}) async {
    try {
      final localTasks = await _offlineService.getTasks(plantingId: plantingId);
      
      if (_connectivityService.isConnected) {
        try {
          var query = SupabaseService.client.from('tasks').select();
          
          if (plantingId != null) {
            query = query.eq('planting_id', plantingId);
          }
          
          final response = await query;
          final remoteTasks = (response as List).map((json) => Task.fromJson(json)).toList();
          
          for (final task in remoteTasks) {
            await _offlineService.insertTask(task);
          }
          
          return Right(remoteTasks);
        } catch (e) {
          debugPrint('Failed to fetch tasks from server, using cache: $e');
        }
      }
      
      return Right(localTasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      await _offlineService.insertTask(task);
      
      if (_connectivityService.isConnected) {
        try {
          final response = await SupabaseService.client
              .from('tasks')
              .insert(task.toJson())
              .select()
              .single();
          
          final serverTask = Task.fromJson(response);
          await _offlineService.insertTask(serverTask);
          
          return Right(serverTask);
        } catch (e) {
          debugPrint('Failed to create task on server, saved locally: $e');
        }
      }
      
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      await _offlineService.updateTask(task);
      
      if (_connectivityService.isConnected) {
        try {
          await SupabaseService.client
              .from('tasks')
              .update(task.toJson())
              .eq('id', task.id);
          
          return Right(task);
        } catch (e) {
          debugPrint('Failed to update task on server, saved locally: $e');
        }
      }
      
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Sync operations
  Future<void> _syncWithServer() async {
    if (!_connectivityService.isConnected) {
      debugPrint('Not connected, skipping sync');
      return;
    }

    try {
      debugPrint('Starting sync with server...');
      await _offlineService.syncWithServer();
      debugPrint('Sync completed successfully');
    } catch (e) {
      debugPrint('Sync failed: $e');
    }
  }

  Future<Either<Failure, void>> forcSync() async {
    try {
      await _syncWithServer();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Utility methods
  Future<Map<String, int>> getCacheStats() async {
    return await _offlineService.getCacheStats();
  }

  Future<int> getPendingSyncCount() async {
    return await _offlineService.getPendingSyncCount();
  }

  bool get isOnline => _connectivityService.isConnected;

  String get connectionStatus => _connectivityService.getConnectionTypeString();

  Stream<bool> get connectionStream => _connectivityService.connectionStream;

  Future<void> clearCache() async {
    await _offlineService.clearCache();
  }

  void dispose() {
    _connectivityService.dispose();
  }
}