import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class NvidiaAIService {
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://integrate.api.nvidia.com/v1';
  
  final Dio _dio = Dio();

  NvidiaAIService() {
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
  }

  /// 🌱 Analisa uma imagem de planta e retorna informações detalhadas
  Future<PlantAnalysisResult> analyzePlantImage(File imageFile) async {
    try {
      // Converte a imagem para base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': 'microsoft/phi-3-vision-128k-instruct',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''
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
'''
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'max_tokens': 1024,
          'temperature': 0.3,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      final jsonMatch = RegExp(r'\{.*\}').firstMatch(content);
      
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final analysisData = json.decode(jsonStr);
        return PlantAnalysisResult.fromJson(analysisData);
      }
      
      throw Exception('Could not parse plant analysis response');
    } catch (e) {
      throw Exception('Failed to analyze plant image: $e');
    }
  }

  /// 🤖 Chat com assistente especializado em jardinagem
  Future<String> chatWithGardenAssistant(String message, {String? imageBase64}) async {
    try {
      List<dynamic> content = [
        {
          'type': 'text',
          'text': '''
Você é um assistente especializado em jardinagem e agricultura urbana.
Responda de forma amigável, prática e útil sobre:
- Cuidados com plantas
- Identificação de problemas
- Dicas de cultivo
- Planejamento de hortas
- Controle orgânico de pragas

Pergunta: $message
'''
        }
      ];

      if (imageBase64 != null) {
        content.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$imageBase64'
          }
        });
      }

      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': 'microsoft/phi-3-vision-128k-instruct',
          'messages': [
            {
              'role': 'user',
              'content': content,
            }
          ],
          'max_tokens': 512,
          'temperature': 0.7,
        },
      );

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      throw Exception('Failed to chat with garden assistant: $e');
    }
  }

  /// 🌟 Gera recomendações inteligentes baseadas no contexto do usuário
  Future<List<GardenRecommendation>> generateRecommendations({
    required String location,
    required String season,
    required List<String> currentPlants,
    required String experienceLevel,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': 'meta/llama-3.1-70b-instruct',
          'messages': [
            {
              'role': 'user',
              'content': '''
Como especialista em jardinagem, gere recomendações personalizadas em JSON:

Contexto:
- Localização: $location
- Estação: $season  
- Plantas atuais: ${currentPlants.join(', ')}
- Nível de experiência: $experienceLevel

Retorne um array JSON com 5 recomendações:
[
  {
    "title": "título da recomendação",
    "description": "descrição detalhada",
    "plant_suggestions": ["lista de plantas"],
    "priority": "high/medium/low",
    "category": "planting/care/maintenance/harvest",
    "estimated_time": "tempo estimado em minutos",
    "difficulty": "easy/medium/hard"
  }
]
'''
            }
          ],
          'max_tokens': 1024,
          'temperature': 0.6,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      final jsonMatch = RegExp(r'\[.*\]').firstMatch(content);
      
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final List<dynamic> recommendationsData = json.decode(jsonStr);
        return recommendationsData
            .map((data) => GardenRecommendation.fromJson(data))
            .toList();
      }
      
      throw Exception('Could not parse recommendations response');
    } catch (e) {
      throw Exception('Failed to generate recommendations: $e');
    }
  }
}

/// 🌱 Resultado da análise de planta
class PlantAnalysisResult {
  final String plantName;
  final String scientificName;
  final String healthStatus;
  final int healthScore;
  final List<String> diseases;
  final List<String> pests;
  final List<String> careTips;
  final String wateringNeeds;
  final String sunlightNeeds;
  final String soilType;
  final String growthStage;
  final int confidence;

  PlantAnalysisResult({
    required this.plantName,
    required this.scientificName,
    required this.healthStatus,
    required this.healthScore,
    required this.diseases,
    required this.pests,
    required this.careTips,
    required this.wateringNeeds,
    required this.sunlightNeeds,
    required this.soilType,
    required this.growthStage,
    required this.confidence,
  });

  factory PlantAnalysisResult.fromJson(Map<String, dynamic> json) {
    return PlantAnalysisResult(
      plantName: json['plant_name'] ?? 'Unknown Plant',
      scientificName: json['scientific_name'] ?? '',
      healthStatus: json['health_status'] ?? 'unknown',
      healthScore: json['health_score'] ?? 0,
      diseases: List<String>.from(json['diseases'] ?? []),
      pests: List<String>.from(json['pests'] ?? []),
      careTips: List<String>.from(json['care_tips'] ?? []),
      wateringNeeds: json['watering_needs'] ?? 'medium',
      sunlightNeeds: json['sunlight_needs'] ?? 'medium',
      soilType: json['soil_type'] ?? 'well-drained',
      growthStage: json['growth_stage'] ?? 'unknown',
      confidence: json['confidence'] ?? 0,
    );
  }
}

/// 🌟 Recomendação personalizada
class GardenRecommendation {
  final String title;
  final String description;
  final List<String> plantSuggestions;
  final String priority;
  final String category;
  final String estimatedTime;
  final String difficulty;

  GardenRecommendation({
    required this.title,
    required this.description,
    required this.plantSuggestions,
    required this.priority,
    required this.category,
    required this.estimatedTime,
    required this.difficulty,
  });

  factory GardenRecommendation.fromJson(Map<String, dynamic> json) {
    return GardenRecommendation(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      plantSuggestions: List<String>.from(json['plant_suggestions'] ?? []),
      priority: json['priority'] ?? 'medium',
      category: json['category'] ?? 'general',
      estimatedTime: json['estimated_time'] ?? '30 minutos',
      difficulty: json['difficulty'] ?? 'medium',
    );
  }
}