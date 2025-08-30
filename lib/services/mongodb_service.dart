import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import '../core/app_config.dart';

class MongoDBService {
  static late Db _database;
  static bool _isInitialized = false;

  // Collections
  static late DbCollection _usersCollection;
  static late DbCollection _farmsCollection;
  static late DbCollection _plotsCollection;
  static late DbCollection _bedsCollection;
  static late DbCollection _cropsCollection;
  static late DbCollection _plantingsCollection;
  static late DbCollection _tasksCollection;

  /// Initialize MongoDB connection
  static Future<void> initialize() async {
    try {
      _database = await Db.create(AppConfig.mongoConnectionString);
      await _database.open();
      
      // Initialize collections
      _usersCollection = _database.collection('users');
      _farmsCollection = _database.collection('farms');
      _plotsCollection = _database.collection('plots');
      _bedsCollection = _database.collection('beds');
      _cropsCollection = _database.collection('crops');
      _plantingsCollection = _database.collection('plantings');
      _tasksCollection = _database.collection('tasks');
      
      _isInitialized = true;
      log('MongoDB connected successfully');
    } catch (e) {
      log('MongoDB connection failed: $e');
      throw Exception('Failed to initialize MongoDB: $e');
    }
  }

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get database instance
  static Db get database {
    if (!_isInitialized) {
      throw Exception('MongoDB not initialized. Call initialize() first.');
    }
    return _database;
  }

  /// Close database connection
  static Future<void> close() async {
    if (_isInitialized) {
      await _database.close();
      _isInitialized = false;
      log('MongoDB connection closed');
    }
  }

  // ============================================================================
  // USER METHODS
  // ============================================================================

  /// Create user profile
  static Future<ObjectId> createUser({
    required String firebaseUid,
    required String name,
    required String email,
    String? phone,
    String? city,
    String? state,
    String? locale,
  }) async {
    try {
      final userData = {
        'firebaseUid': firebaseUid,
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
        'state': state,
        'locale': locale ?? 'pt-BR',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _usersCollection.insertOne(userData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by Firebase UID
  static Future<Map<String, dynamic>?> getUserByFirebaseUid(String firebaseUid) async {
    try {
      return await _usersCollection.findOne(where.eq('firebaseUid', firebaseUid));
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user profile
  static Future<void> updateUser(ObjectId userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _usersCollection.updateOne(
        where.eq('_id', userId),
        modify.set('', updates),
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // ============================================================================
  // FARM METHODS
  // ============================================================================

  /// Create farm
  static Future<ObjectId> createFarm({
    required ObjectId userId,
    required String name,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final farmData = {
        'userId': userId,
        'name': name,
        'description': description,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _farmsCollection.insertOne(farmData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create farm: $e');
    }
  }

  /// Get farms by user
  static Future<List<Map<String, dynamic>>> getFarmsByUser(ObjectId userId) async {
    try {
      return await _farmsCollection
          .find(where.eq('userId', userId))
          .toList();
    } catch (e) {
      throw Exception('Failed to get farms: $e');
    }
  }

  /// Get farm by ID
  static Future<Map<String, dynamic>?> getFarmById(ObjectId farmId) async {
    try {
      return await _farmsCollection.findOne(where.eq('_id', farmId));
    } catch (e) {
      throw Exception('Failed to get farm: $e');
    }
  }

  // ============================================================================
  // PLOT METHODS
  // ============================================================================

  /// Create plot
  static Future<ObjectId> createPlot({
    required ObjectId farmId,
    required String label,
    required double lengthM,
    required double widthM,
    required double pathGapM,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final plotData = {
        'farmId': farmId,
        'label': label,
        'lengthM': lengthM,
        'widthM': widthM,
        'pathGapM': pathGapM,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _plotsCollection.insertOne(plotData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create plot: $e');
    }
  }

  /// Get plots by farm
  static Future<List<Map<String, dynamic>>> getPlotsByFarm(ObjectId farmId) async {
    try {
      return await _plotsCollection
          .find(where.eq('farmId', farmId))
          .toList();
    } catch (e) {
      throw Exception('Failed to get plots: $e');
    }
  }

  // ============================================================================
  // BED METHODS
  // ============================================================================

  /// Create bed
  static Future<ObjectId> createBed({
    required ObjectId plotId,
    required double x,
    required double y,
    required double widthM,
    required double heightM,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final bedData = {
        'plotId': plotId,
        'x': x,
        'y': y,
        'widthM': widthM,
        'heightM': heightM,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _bedsCollection.insertOne(bedData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create bed: $e');
    }
  }

  /// Create multiple beds
  static Future<List<ObjectId>> createMultipleBeds(List<Map<String, dynamic>> bedsData) async {
    try {
      final now = DateTime.now();
      for (final bedData in bedsData) {
        bedData['createdAt'] = now;
        bedData['updatedAt'] = now;
      }

      await _bedsCollection.insertMany(bedsData);
      return [];
    } catch (e) {
      throw Exception('Failed to create beds: $e');
    }
  }

  /// Get beds by plot
  static Future<List<Map<String, dynamic>>> getBedsByPlot(ObjectId plotId) async {
    try {
      return await _bedsCollection
          .find(where.eq('plotId', plotId))
          .toList();
    } catch (e) {
      throw Exception('Failed to get beds: $e');
    }
  }

  // ============================================================================
  // CROP METHODS
  // ============================================================================

  /// Create crop
  static Future<ObjectId> createCrop({
    required String name,
    required String category,
    required int cycleDays,
    required double rowSpacingM,
    required double plantSpacingM,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final cropData = {
        'name': name,
        'category': category,
        'cycleDays': cycleDays,
        'rowSpacingM': rowSpacingM,
        'plantSpacingM': plantSpacingM,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _cropsCollection.insertOne(cropData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create crop: $e');
    }
  }

  /// Get all crops
  static Future<List<Map<String, dynamic>>> getAllCrops() async {
    try {
      return await _cropsCollection.find().toList();
    } catch (e) {
      throw Exception('Failed to get crops: $e');
    }
  }

  /// Get crops by category
  static Future<List<Map<String, dynamic>>> getCropsByCategory(String category) async {
    try {
      return await _cropsCollection
          .find(where.eq('category', category))
          .toList();
    } catch (e) {
      throw Exception('Failed to get crops by category: $e');
    }
  }

  // ============================================================================
  // PLANTING METHODS
  // ============================================================================

  /// Create planting
  static Future<ObjectId> createPlanting({
    required ObjectId bedId,
    required ObjectId cropId,
    required DateTime sowingDate,
    required DateTime harvestEstimate,
    required int quantity,
    int? customCycleDays,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final plantingData = {
        'bedId': bedId,
        'cropId': cropId,
        'sowingDate': sowingDate,
        'harvestEstimate': harvestEstimate,
        'quantity': quantity,
        'customCycleDays': customCycleDays,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _plantingsCollection.insertOne(plantingData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create planting: $e');
    }
  }

  /// Get plantings by bed
  static Future<List<Map<String, dynamic>>> getPlantingsByBed(ObjectId bedId) async {
    try {
      return await _plantingsCollection
          .find(where.eq('bedId', bedId))
          .toList();
    } catch (e) {
      throw Exception('Failed to get plantings: $e');
    }
  }

  // ============================================================================
  // TASK METHODS
  // ============================================================================

  /// Create task
  static Future<ObjectId> createTask({
    required ObjectId plantingId,
    required String type,
    required DateTime dueDate,
    String? description,
    bool isCompleted = false,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final taskData = {
        'plantingId': plantingId,
        'type': type,
        'dueDate': dueDate,
        'description': description,
        'isCompleted': isCompleted,
        'completedAt': completedAt,
        'metadata': metadata ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final result = await _tasksCollection.insertOne(taskData);
      return result.id as ObjectId;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Create multiple tasks
  static Future<List<ObjectId>> createMultipleTasks(List<Map<String, dynamic>> tasksData) async {
    try {
      final now = DateTime.now();
      for (final taskData in tasksData) {
        taskData['isCompleted'] = false;
        taskData['createdAt'] = now;
        taskData['updatedAt'] = now;
      }

      await _tasksCollection.insertMany(tasksData);
      return [];
    } catch (e) {
      throw Exception('Failed to create tasks: $e');
    }
  }

  /// Get tasks by planting
  static Future<List<Map<String, dynamic>>> getTasksByPlanting(ObjectId plantingId) async {
    try {
      return await _tasksCollection
          .find(where.eq('plantingId', plantingId))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  /// Get tasks by user (through joins)
  static Future<List<Map<String, dynamic>>> getTasksByUser(ObjectId userId) async {
    try {
      // This would require aggregation pipeline for joins
      // For now, simplified version
      final farms = await getFarmsByUser(userId);
      final List<Map<String, dynamic>> allTasks = [];
      
      for (final farm in farms) {
        final plots = await getPlotsByFarm(farm['_id']);
        for (final plot in plots) {
          final beds = await getBedsByPlot(plot['_id']);
          for (final bed in beds) {
            final plantings = await getPlantingsByBed(bed['_id']);
            for (final planting in plantings) {
              final tasks = await getTasksByPlanting(planting['_id']);
              allTasks.addAll(tasks);
            }
          }
        }
      }
      
      return allTasks;
    } catch (e) {
      throw Exception('Failed to get user tasks: $e');
    }
  }

  /// Update task completion status
  static Future<void> completeTask(ObjectId taskId) async {
    try {
      await _tasksCollection.updateOne(
        where.eq('_id', taskId),
        modify.set('isCompleted', true).set('completedAt', DateTime.now()).set('updatedAt', DateTime.now()),
      );
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Convert ObjectId to string
  static String objectIdToString(ObjectId objectId) {
    return objectId.oid;
  }

  /// Convert string to ObjectId
  static ObjectId stringToObjectId(String id) {
    return ObjectId.fromHexString(id);
  }

  /// Check if user has completed onboarding
  static Future<bool> hasUserCompletedOnboarding(ObjectId userId) async {
    try {
      final farms = await getFarmsByUser(userId);
      return farms.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}