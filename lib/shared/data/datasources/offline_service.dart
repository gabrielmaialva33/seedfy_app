import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/bed.dart';
import '../../domain/entities/crop.dart';
import '../../domain/entities/farm.dart';
import '../../domain/entities/planting.dart';
import '../../domain/entities/plot.dart';
import '../../domain/entities/task.dart';

class OfflineService {
  static Database? _database;
  static const String _dbName = 'seedfy_offline.db';
  static const int _dbVersion = 1;

  // Singleton pattern
  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;
  OfflineService._internal();

  // Database initialization
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/$_dbName';
    
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Farms table
    await db.execute('''
      CREATE TABLE farms (
        id TEXT PRIMARY KEY,
        owner_id TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT
      )
    ''');

    // Plots table
    await db.execute('''
      CREATE TABLE plots (
        id TEXT PRIMARY KEY,
        farm_id TEXT NOT NULL,
        label TEXT NOT NULL,
        length_m REAL NOT NULL,
        width_m REAL NOT NULL,
        path_gap_m REAL NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT,
        FOREIGN KEY (farm_id) REFERENCES farms (id)
      )
    ''');

    // Beds table
    await db.execute('''
      CREATE TABLE beds (
        id TEXT PRIMARY KEY,
        plot_id TEXT NOT NULL,
        x INTEGER NOT NULL,
        y INTEGER NOT NULL,
        width_m REAL NOT NULL,
        height_m REAL NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT,
        FOREIGN KEY (plot_id) REFERENCES plots (id)
      )
    ''');

    // Crops catalog table
    await db.execute('''
      CREATE TABLE crops_catalog (
        id TEXT PRIMARY KEY,
        name_pt TEXT NOT NULL,
        name_en TEXT NOT NULL,
        cycle_days INTEGER NOT NULL,
        plant_spacing_m REAL NOT NULL,
        row_spacing_m REAL NOT NULL,
        image_url TEXT,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT
      )
    ''');

    // Plantings table
    await db.execute('''
      CREATE TABLE plantings (
        id TEXT PRIMARY KEY,
        bed_id TEXT NOT NULL,
        crop_id TEXT NOT NULL,
        custom_cycle_days INTEGER,
        sowing_date TEXT NOT NULL,
        harvest_estimate TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT,
        FOREIGN KEY (bed_id) REFERENCES beds (id),
        FOREIGN KEY (crop_id) REFERENCES crops_catalog (id)
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        planting_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        due_date TEXT NOT NULL,
        sowing_date TEXT,
        harvest_date TEXT,
        done INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        completed_by TEXT,
        notes TEXT,
        estimated_minutes INTEGER,
        actual_minutes INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced',
        last_modified TEXT,
        FOREIGN KEY (planting_id) REFERENCES plantings (id)
      )
    ''');

    // Sync queue table for tracking pending operations
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        last_retry TEXT
      )
    ''');

    debugPrint('Offline database created successfully');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < newVersion) {
      debugPrint('Upgrading database from version $oldVersion to $newVersion');
    }
  }

  // CRUD Operations for Farms
  Future<void> insertFarm(Farm farm) async {
    final db = await database;
    await db.insert(
      'farms',
      {
        ...farm.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Add to sync queue
    await _addToSyncQueue('farms', farm.id, 'INSERT', farm.toJson());
  }

  Future<List<Farm>> getFarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('farms');
    
    return List.generate(maps.length, (i) {
      return Farm.fromJson(maps[i]);
    });
  }

  Future<void> updateFarm(Farm farm) async {
    final db = await database;
    await db.update(
      'farms',
      {
        ...farm.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [farm.id],
    );
    
    await _addToSyncQueue('farms', farm.id, 'UPDATE', farm.toJson());
  }

  Future<void> deleteFarm(String farmId) async {
    final db = await database;
    await db.delete('farms', where: 'id = ?', whereArgs: [farmId]);
    await _addToSyncQueue('farms', farmId, 'DELETE', null);
  }

  // CRUD Operations for Plots
  Future<void> insertPlot(Plot plot) async {
    final db = await database;
    await db.insert(
      'plots',
      {
        ...plot.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    await _addToSyncQueue('plots', plot.id, 'INSERT', plot.toJson());
  }

  Future<List<Plot>> getPlots(String farmId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plots',
      where: 'farm_id = ?',
      whereArgs: [farmId],
    );
    
    return List.generate(maps.length, (i) {
      return Plot.fromJson(maps[i]);
    });
  }

  // CRUD Operations for Beds
  Future<void> insertBed(Bed bed) async {
    final db = await database;
    await db.insert(
      'beds',
      {
        ...bed.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    await _addToSyncQueue('beds', bed.id, 'INSERT', bed.toJson());
  }

  Future<List<Bed>> getBeds(String plotId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'beds',
      where: 'plot_id = ?',
      whereArgs: [plotId],
    );
    
    return List.generate(maps.length, (i) {
      return Bed.fromJson(maps[i]);
    });
  }

  Future<void> updateBed(Bed bed) async {
    final db = await database;
    await db.update(
      'beds',
      {
        ...bed.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [bed.id],
    );
    
    await _addToSyncQueue('beds', bed.id, 'UPDATE', bed.toJson());
  }

  Future<void> deleteBed(String bedId) async {
    final db = await database;
    await db.delete('beds', where: 'id = ?', whereArgs: [bedId]);
    await _addToSyncQueue('beds', bedId, 'DELETE', null);
  }

  // CRUD Operations for Crops
  Future<void> insertCrop(Crop crop) async {
    final db = await database;
    await db.insert(
      'crops_catalog',
      {
        ...crop.toJson(),
        'sync_status': 'synced', // Crops are usually synced from server
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Crop>> getCrops() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('crops_catalog');
    
    return List.generate(maps.length, (i) {
      return Crop.fromJson(maps[i]);
    });
  }

  // CRUD Operations for Plantings
  Future<void> insertPlanting(Planting planting) async {
    final db = await database;
    await db.insert(
      'plantings',
      {
        ...planting.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    await _addToSyncQueue('plantings', planting.id, 'INSERT', planting.toJson());
  }

  Future<List<Planting>> getPlantings(String bedId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plantings',
      where: 'bed_id = ?',
      whereArgs: [bedId],
    );
    
    return List.generate(maps.length, (i) {
      return Planting.fromJson(maps[i]);
    });
  }

  Future<void> updatePlanting(Planting planting) async {
    final db = await database;
    await db.update(
      'plantings',
      {
        ...planting.toJson(),
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [planting.id],
    );
    
    await _addToSyncQueue('plantings', planting.id, 'UPDATE', planting.toJson());
  }

  // CRUD Operations for Tasks
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        ...task.toJson(),
        'done': task.done ? 1 : 0,
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    await _addToSyncQueue('tasks', task.id, 'INSERT', task.toJson());
  }

  Future<List<Task>> getTasks({String? plantingId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = plantingId != null
        ? await db.query('tasks', where: 'planting_id = ?', whereArgs: [plantingId])
        : await db.query('tasks');
    
    return List.generate(maps.length, (i) {
      final taskData = Map<String, dynamic>.from(maps[i]);
      taskData['done'] = taskData['done'] == 1; // Convert int to bool
      return Task.fromJson(taskData);
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        ...task.toJson(),
        'done': task.done ? 1 : 0,
        'sync_status': 'pending',
        'last_modified': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
    
    await _addToSyncQueue('tasks', task.id, 'UPDATE', task.toJson());
  }

  // Sync Queue Management
  Future<void> _addToSyncQueue(
    String tableName,
    String recordId,
    String operation,
    Map<String, dynamic>? data,
  ) async {
    final db = await database;
    await db.insert('sync_queue', {
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'data': data != null ? jsonEncode(data) : null,
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query(
      'sync_queue',
      orderBy: 'created_at ASC',
      limit: 50, // Process in batches
    );
  }

  Future<void> markAsSynced(int syncQueueId, String tableName, String recordId) async {
    final db = await database;
    
    // Remove from sync queue
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [syncQueueId]);
    
    // Update record sync status
    await db.update(
      tableName,
      {'sync_status': 'synced'},
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }

  Future<void> markSyncFailed(int syncQueueId) async {
    final db = await database;
    await db.update(
      'sync_queue',
      {
        'retry_count': 'retry_count + 1',
        'last_retry': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [syncQueueId],
    );
  }

  // Data synchronization with remote server
  Future<void> syncWithServer() async {
    try {
      final pendingItems = await getPendingSyncItems();
      
      for (final item in pendingItems) {
        try {
          final success = await _syncItem(item);
          if (success) {
            await markAsSynced(
              item['id'] as int,
              item['table_name'] as String,
              item['record_id'] as String,
            );
          } else {
            await markSyncFailed(item['id'] as int);
          }
        } catch (e) {
          debugPrint('Error syncing item ${item['id']}: $e');
          await markSyncFailed(item['id'] as int);
        }
      }
    } catch (e) {
      debugPrint('Error during sync: $e');
    }
  }

  Future<bool> _syncItem(Map<String, dynamic> item) async {
    // This would implement the actual sync logic with Supabase
    // For now, we'll simulate the sync process
    await Future.delayed(const Duration(milliseconds: 100));
    
    // In a real implementation, this would:
    // 1. Parse the item data
    // 2. Make appropriate Supabase API calls based on operation type
    // 3. Handle conflicts and errors
    // 4. Return true if successful, false otherwise
    
    return true; // Simulate successful sync
  }

  // Utility methods
  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.query(
      'sync_queue',
      columns: ['COUNT(*) as count'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearCache() async {
    final db = await database;
    
    // Clear all tables but keep structure
    await db.delete('farms');
    await db.delete('plots');
    await db.delete('beds');
    await db.delete('crops_catalog');
    await db.delete('plantings');
    await db.delete('tasks');
    await db.delete('sync_queue');
    
    debugPrint('Offline cache cleared');
  }

  Future<Map<String, int>> getCacheStats() async {
    final db = await database;
    
    final stats = <String, int>{};
    
    final tables = ['farms', 'plots', 'beds', 'crops_catalog', 'plantings', 'tasks'];
    
    for (final table in tables) {
      final result = await db.query(table, columns: ['COUNT(*) as count']);
      stats[table] = Sqflite.firstIntValue(result) ?? 0;
    }
    
    stats['pending_sync'] = await getPendingSyncCount();
    
    return stats;
  }

  // Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}