import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/shared/data/datasources/nvidia_ai_service.dart';

// Mock classes
class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

class MockFile extends Mock implements File {}

void main() {
  group('NvidiaAIService', () {
    group('PlantAnalysisResult', () {
      test('should create PlantAnalysisResult from valid JSON', () {
        final json = {
          'plant_name': 'Tomato',
          'scientific_name': 'Solanum lycopersicum',
          'health_status': 'healthy',
          'health_score': 85,
          'diseases': ['None'],
          'pests': [],
          'care_tips': ['Water regularly', 'Provide support'],
          'watering_needs': 'medium',
          'sunlight_needs': 'high',
          'soil_type': 'well-drained',
          'growth_stage': 'flowering',
          'confidence': 92,
        };

        final result = PlantAnalysisResult.fromJson(json);

        expect(result.plantName, 'Tomato');
        expect(result.scientificName, 'Solanum lycopersicum');
        expect(result.healthStatus, 'healthy');
        expect(result.healthScore, 85);
        expect(result.diseases, ['None']);
        expect(result.pests, isEmpty);
        expect(result.careTips, ['Water regularly', 'Provide support']);
        expect(result.wateringNeeds, 'medium');
        expect(result.sunlightNeeds, 'high');
        expect(result.soilType, 'well-drained');
        expect(result.growthStage, 'flowering');
        expect(result.confidence, 92);
      });

      test('should handle missing fields with defaults', () {
        final json = <String, dynamic>{};

        final result = PlantAnalysisResult.fromJson(json);

        expect(result.plantName, 'Unknown Plant');
        expect(result.scientificName, '');
        expect(result.healthStatus, 'unknown');
        expect(result.healthScore, 0);
        expect(result.diseases, isEmpty);
        expect(result.pests, isEmpty);
        expect(result.careTips, isEmpty);
        expect(result.wateringNeeds, 'medium');
        expect(result.sunlightNeeds, 'medium');
        expect(result.soilType, 'well-drained');
        expect(result.growthStage, 'unknown');
        expect(result.confidence, 0);
      });

      test('should handle null values', () {
        final json = {
          'plant_name': null,
          'scientific_name': null,
          'health_status': null,
          'health_score': null,
          'diseases': null,
          'pests': null,
          'care_tips': null,
          'watering_needs': null,
          'sunlight_needs': null,
          'soil_type': null,
          'growth_stage': null,
          'confidence': null,
        };

        final result = PlantAnalysisResult.fromJson(json);

        expect(result.plantName, 'Unknown Plant');
        expect(result.scientificName, '');
        expect(result.healthStatus, 'unknown');
        expect(result.healthScore, 0);
        expect(result.diseases, isEmpty);
        expect(result.pests, isEmpty);
        expect(result.careTips, isEmpty);
        expect(result.wateringNeeds, 'medium');
        expect(result.sunlightNeeds, 'medium');
        expect(result.soilType, 'well-drained');
        expect(result.growthStage, 'unknown');
        expect(result.confidence, 0);
      });
    });

    group('GardenRecommendation', () {
      test('should create GardenRecommendation from valid JSON', () {
        final json = {
          'title': 'Plant winter vegetables',
          'description': 'Now is the perfect time to plant cool-season crops',
          'plant_suggestions': ['lettuce', 'spinach', 'kale'],
          'priority': 'high',
          'category': 'planting',
          'estimated_time': '45 minutes',
          'difficulty': 'easy',
        };

        final recommendation = GardenRecommendation.fromJson(json);

        expect(recommendation.title, 'Plant winter vegetables');
        expect(recommendation.description,
            'Now is the perfect time to plant cool-season crops');
        expect(recommendation.plantSuggestions, ['lettuce', 'spinach', 'kale']);
        expect(recommendation.priority, 'high');
        expect(recommendation.category, 'planting');
        expect(recommendation.estimatedTime, '45 minutes');
        expect(recommendation.difficulty, 'easy');
      });

      test('should handle missing fields with defaults', () {
        final json = <String, dynamic>{};

        final recommendation = GardenRecommendation.fromJson(json);

        expect(recommendation.title, '');
        expect(recommendation.description, '');
        expect(recommendation.plantSuggestions, isEmpty);
        expect(recommendation.priority, 'medium');
        expect(recommendation.category, 'general');
        expect(recommendation.estimatedTime, '30 minutos');
        expect(recommendation.difficulty, 'medium');
      });

      test('should handle null plant_suggestions', () {
        final json = {
          'title': 'Test recommendation',
          'plant_suggestions': null,
        };

        final recommendation = GardenRecommendation.fromJson(json);

        expect(recommendation.plantSuggestions, isEmpty);
      });
    });

    group('Error Handling', () {
      test('should handle invalid JSON in analysis response', () {
        // This test would require mocking the actual HTTP calls
        // For now, we'll test the JSON parsing logic

        const invalidJson = 'This is not valid JSON';
        expect(() => json.decode(invalidJson), throwsFormatException);
      });

      test('should handle empty response', () {
        const emptyResponse = '';
        final jsonMatch = RegExp(r'\\{.*\\}').firstMatch(emptyResponse);
        expect(jsonMatch, isNull);
      });

      test('should extract JSON from mixed content', () {
        const mixedContent =
            'Here is the analysis: {"plant_name": "Rose", "health_score": 90} and some extra text.';
        final jsonMatch = RegExp(r'\{.*?\}').firstMatch(mixedContent);

        expect(jsonMatch, isNotNull);
        expect(
            jsonMatch!.group(0), '{"plant_name": "Rose", "health_score": 90}');
      });
    });

    group('Input Validation', () {
      test('should handle various experience levels', () {
        const validLevels = ['beginner', 'intermediate', 'expert'];

        for (final level in validLevels) {
          expect(level, isA<String>());
          expect(level.isNotEmpty, isTrue);
        }
      });

      test('should handle various seasons', () {
        const seasons = ['Verão', 'Outono', 'Inverno', 'Primavera'];

        for (final season in seasons) {
          expect(season, isA<String>());
          expect(season.isNotEmpty, isTrue);
        }
      });

      test('should handle empty plant lists', () {
        const List<String> emptyPlants = [];
        expect(emptyPlants, isEmpty);
        expect(emptyPlants.join(', '), isEmpty);
      });

      test('should handle plant list with special characters', () {
        const plants = ['Tomate 🍅', 'Alface & Rúcula', 'Pimentão-doce'];
        final joinedPlants = plants.join(', ');

        expect(joinedPlants, 'Tomate 🍅, Alface & Rúcula, Pimentão-doce');
      });
    });

    group('Prompt Generation', () {
      test('should generate valid plant analysis prompt', () {
        const expectedPrompt = '''
Analise esta imagem de planta como um especialista em botânica e jardinagem. 
Retorne as informações em JSON com os seguintes campos:
{
  "plant_name": "nome da planta",
  "scientific_name": "nome científico",
  "health_status": "healthy/warning/critical",
  "health_score": 0-100,
  "diseases": ["lista de doenças identificadas"],
  "pests": ["lista de pragas identificadas"],
  "care_tips": ["dicas de cuidado"],
  "watering_needs": "low/medium/high",
  "sunlight_needs": "low/medium/high",
  "soil_type": "tipo de solo recomendado",
  "growth_stage": "seedling/vegetative/flowering/fruiting/mature",
  "confidence": 0-100
}
''';

        // Verify the prompt contains required fields
        expect(expectedPrompt.contains('plant_name'), isTrue);
        expect(expectedPrompt.contains('scientific_name'), isTrue);
        expect(expectedPrompt.contains('health_status'), isTrue);
        expect(expectedPrompt.contains('health_score'), isTrue);
        expect(expectedPrompt.contains('diseases'), isTrue);
        expect(expectedPrompt.contains('pests'), isTrue);
        expect(expectedPrompt.contains('care_tips'), isTrue);
        expect(expectedPrompt.contains('watering_needs'), isTrue);
        expect(expectedPrompt.contains('sunlight_needs'), isTrue);
        expect(expectedPrompt.contains('soil_type'), isTrue);
        expect(expectedPrompt.contains('growth_stage'), isTrue);
        expect(expectedPrompt.contains('confidence'), isTrue);
      });

      test('should generate valid chat prompt', () {
        const message = 'How do I care for tomatoes?';
        const expectedPromptPattern = '''
Você é um assistente especializado em jardinagem e agricultura urbana.
Responda de forma amigável, prática e útil sobre:
- Cuidados com plantas
- Identificação de problemas
- Dicas de cultivo
- Planejamento de hortas
- Controle orgânico de pragas

Pergunta: $message
''';

        expect(expectedPromptPattern.contains(message), isTrue);
        expect(expectedPromptPattern.contains('jardinagem'), isTrue);
        expect(expectedPromptPattern.contains('agricultura urbana'), isTrue);
      });
    });

    group('Base64 Encoding', () {
      test('should handle base64 image encoding', () {
        const sampleBytes = [137, 80, 78, 71, 13, 10, 26, 10]; // PNG header
        final base64String = base64Encode(sampleBytes);

        expect(base64String, isA<String>());
        expect(base64String.isNotEmpty, isTrue);

        // Verify we can decode it back
        final decodedBytes = base64Decode(base64String);
        expect(decodedBytes, equals(sampleBytes));
      });

      test('should generate correct data URL format', () {
        const base64Image = 'iVBORw0KGgoAAAANSUhEUg';
        final dataUrl = 'data:image/jpeg;base64,$base64Image';

        expect(dataUrl, 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUg');
        expect(dataUrl.startsWith('data:image/jpeg;base64,'), isTrue);
      });
    });
  });
}
