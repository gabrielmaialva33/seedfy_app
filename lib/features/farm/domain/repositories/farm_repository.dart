import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/farm.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/planting.dart';

abstract class FarmRepository {
  /// Get all farms for the current user
  Future<Either<Failure, List<Farm>>> getUserFarms();
  
  /// Get a specific farm by ID
  Future<Either<Failure, Farm>> getFarm(String farmId);
  
  /// Create a new farm
  Future<Either<Failure, Farm>> createFarm(Farm farm);
  
  /// Update an existing farm
  Future<Either<Failure, Farm>> updateFarm(Farm farm);
  
  /// Delete a farm
  Future<Either<Failure, void>> deleteFarm(String farmId);
  
  /// Get all plots for a specific farm
  Future<Either<Failure, List<Plot>>> getFarmPlots(String farmId);
  
  /// Get all beds for a specific farm
  Future<Either<Failure, List<Bed>>> getFarmBeds(String farmId);
  
  /// Get all active plantings for a specific farm
  Future<Either<Failure, List<Planting>>> getFarmPlantings(String farmId);
  
  /// Get farm statistics (total plants, active tasks, etc.)
  Future<Either<Failure, Map<String, dynamic>>> getFarmStats(String farmId);
}