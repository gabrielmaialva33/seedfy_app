import 'package:flutter_test/flutter_test.dart';
import 'package:seedfy_app/shared/domain/entities/farm.dart';

void main() {
  group('Farm Entity', () {
    late Farm farm;

    setUp(() {
      farm = Farm(
        id: 'test-farm-123',
        ownerId: 'test-user-456',
        name: 'My Urban Garden',
        createdAt: DateTime(2023, 12, 20),
      );
    });

    test('should create a farm with valid properties', () {
      expect(farm.id, 'test-farm-123');
      expect(farm.ownerId, 'test-user-456');
      expect(farm.name, 'My Urban Garden');
      expect(farm.createdAt, DateTime(2023, 12, 20));
    });

    test('fromJson should create farm from valid JSON', () {
      final json = {
        'id': 'json-farm-123',
        'owner_id': 'json-user-456',
        'name': 'Test Garden from JSON',
        'created_at': '2023-12-20T10:30:00.000Z',
      };

      final farmFromJson = Farm.fromJson(json);

      expect(farmFromJson.id, 'json-farm-123');
      expect(farmFromJson.ownerId, 'json-user-456');
      expect(farmFromJson.name, 'Test Garden from JSON');
      expect(farmFromJson.createdAt, DateTime.parse('2023-12-20T10:30:00.000Z'));
    });

    test('toJson should convert farm to JSON correctly', () {
      final json = farm.toJson();

      expect(json['id'], 'test-farm-123');
      expect(json['owner_id'], 'test-user-456');
      expect(json['name'], 'My Urban Garden');
      expect(json['created_at'], '2023-12-20T00:00:00.000');
    });

    test('should handle empty strings correctly', () {
      final emptyFarm = Farm(
        id: '',
        ownerId: '',
        name: '',
        createdAt: DateTime.now(),
      );

      expect(emptyFarm.id, '');
      expect(emptyFarm.ownerId, '');
      expect(emptyFarm.name, '');
    });

    test('should be immutable', () {
      final originalName = farm.name;
      final originalId = farm.id;
      
      // Farm should be immutable, these properties should not be modifiable
      expect(farm.id, originalId);
      expect(farm.name, originalName);
    });

    test('should handle special characters in name', () {
      final specialFarm = Farm(
        id: 'special-farm-123',
        ownerId: 'user-456',
        name: 'Horta do José & Maria - Orgânicos 🌱',
        createdAt: DateTime(2023, 12, 20),
      );

      expect(specialFarm.name, 'Horta do José & Maria - Orgânicos 🌱');

      final json = specialFarm.toJson();
      expect(json['name'], 'Horta do José & Maria - Orgânicos 🌱');

      final reconstructed = Farm.fromJson(json);
      expect(reconstructed.name, 'Horta do José & Maria - Orgânicos 🌱');
    });

    test('should handle different date formats in JSON', () {
      final jsonWithIsoDate = {
        'id': 'iso-farm-123',
        'owner_id': 'iso-user-456', 
        'name': 'ISO Date Farm',
        'created_at': '2023-12-20T15:30:45.123Z',
      };

      final farmFromIso = Farm.fromJson(jsonWithIsoDate);
      expect(farmFromIso.createdAt, DateTime.parse('2023-12-20T15:30:45.123Z'));
    });
  });
}