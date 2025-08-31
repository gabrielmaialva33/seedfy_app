import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../shared/data/datasources/nvidia_ai_service.dart';
import '../../../shared/data/datasources/supabase_service.dart';

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({super.key});

  @override
  State<AIRecommendationsScreen> createState() => _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  final NvidiaAIService _aiService = NvidiaAIService();
  List<GardenRecommendation> _recommendations = [];
  bool _isLoading = true;
  String? _error;
  String _location = '';
  String _season = '';
  List<String> _currentPlants = [];
  String _experienceLevel = 'beginner';

  @override
  void initState() {
    super.initState();
    _loadUserContext();
  }

  Future<void> _loadUserContext() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Load user profile for location context
      final profileResponse = await SupabaseService.client
          .from('profiles')
          .select('city, state')
          .eq('id', userId)
          .maybeSingle();

      if (profileResponse != null) {
        _location = '${profileResponse['city']}, ${profileResponse['state']}';
      }

      // Load current plants from user's beds
      final bedsResponse = await SupabaseService.client
          .from('beds')
          .select('''
            plantings(
              crops_catalog(name_pt, name_en)
            )
          ''');

      _currentPlants = [];
      for (final bed in bedsResponse) {
        if (bed['plantings'] != null && (bed['plantings'] as List).isNotEmpty) {
          final planting = (bed['plantings'] as List).first;
          if (planting['crops_catalog'] != null) {
            _currentPlants.add(planting['crops_catalog']['name_pt']);
          }
        }
      }

      // Determine current season
      final now = DateTime.now();
      final month = now.month;
      if (month >= 12 || month <= 2) {
        _season = 'Verão';
      } else if (month >= 3 && month <= 5) {
        _season = 'Outono';
      } else if (month >= 6 && month <= 8) {
        _season = 'Inverno';
      } else {
        _season = 'Primavera';
      }

      await _generateRecommendations();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _generateRecommendations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final recommendations = await _aiService.generateRecommendations(
        location: _location.isNotEmpty ? _location : 'Brasil',
        season: _season,
        currentPlants: _currentPlants,
        experienceLevel: _experienceLevel,
      );

      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPortuguese ? '🤖 Recomendações IA' : '🤖 AI Recommendations',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateRecommendations,
            tooltip: isPortuguese ? 'Atualizar recomendações' : 'Refresh recommendations',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune),
            tooltip: isPortuguese ? 'Configurações' : 'Settings',
            onSelected: (value) {
              setState(() {
                _experienceLevel = value;
              });
              _generateRecommendations();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'beginner',
                child: Row(
                  children: [
                    Icon(Icons.school, color: _experienceLevel == 'beginner' ? Colors.green : null),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Iniciante' : 'Beginner'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'intermediate',
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: _experienceLevel == 'intermediate' ? Colors.green : null),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Intermediário' : 'Intermediate'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'expert',
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: _experienceLevel == 'expert' ? Colors.green : null),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Especialista' : 'Expert'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: _buildBody(isPortuguese, theme),
      ),
    );
  }

  Widget _buildBody(bool isPortuguese, ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3,
            ).animate().scale(),
            const SizedBox(height: 24),
            Text(
              isPortuguese 
                  ? '🧠 Gerando recomendações personalizadas...' 
                  : '🧠 Generating personalized recommendations...',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              isPortuguese
                  ? 'Analisando seu perfil, localização e plantas atuais'
                  : 'Analyzing your profile, location and current plants',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ).animate().scale(),
            const SizedBox(height: 16),
            Text(
              isPortuguese ? 'Erro ao gerar recomendações' : 'Error generating recommendations',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateRecommendations,
              child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
            ),
          ],
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.amber[400],
            ).animate().scale(),
            const SizedBox(height: 16),
            Text(
              isPortuguese ? 'Nenhuma recomendação disponível' : 'No recommendations available',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isPortuguese 
                  ? 'Adicione algumas plantas ao seu jardim primeiro'
                  : 'Add some plants to your garden first',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _generateRecommendations,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Context card
          _buildContextCard(isPortuguese, theme),
          const SizedBox(height: 16),
          
          // Recommendations header
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                isPortuguese 
                    ? 'Recomendações Personalizadas'
                    : 'Personalized Recommendations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ).animate().fadeIn().slideX(),
          const SizedBox(height: 16),

          // Recommendations list
          ..._recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final recommendation = entry.value;
            return _buildRecommendationCard(recommendation, isPortuguese, theme, index);
          }),
        ],
      ),
    );
  }

  Widget _buildContextCard(bool isPortuguese, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                isPortuguese ? 'Contexto da Análise' : 'Analysis Context',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildContextItem(
            Icons.location_on,
            isPortuguese ? 'Localização' : 'Location',
            _location.isNotEmpty ? _location : (isPortuguese ? 'Não informado' : 'Not specified'),
            theme,
          ),
          _buildContextItem(
            Icons.calendar_today,
            isPortuguese ? 'Estação' : 'Season',
            _season,
            theme,
          ),
          _buildContextItem(
            Icons.local_florist,
            isPortuguese ? 'Plantas atuais' : 'Current plants',
            _currentPlants.isEmpty 
                ? (isPortuguese ? 'Nenhuma planta cadastrada' : 'No plants registered')
                : '${_currentPlants.length} ${isPortuguese ? "espécies" : "species"}',
            theme,
          ),
          _buildContextItem(
            Icons.star,
            isPortuguese ? 'Experiência' : 'Experience',
            _getExperienceLevelText(isPortuguese),
            theme,
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildContextItem(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(GardenRecommendation recommendation, bool isPortuguese, ThemeData theme, int index) {
    final priorityColor = _getPriorityColor(recommendation.priority);
    final categoryIcon = _getCategoryIcon(recommendation.category);
    final difficultyIcon = _getDifficultyIcon(recommendation.difficulty);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(categoryIcon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPriorityText(recommendation.priority, isPortuguese),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                
                if (recommendation.plantSuggestions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    isPortuguese ? '🌱 Plantas sugeridas:' : '🌱 Suggested plants:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recommendation.plantSuggestions.map((plant) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          plant,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ).toList(),
                  ),
                ],

                const SizedBox(height: 16),
                
                // Footer info
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(
                      recommendation.estimatedTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    Icon(difficultyIcon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(
                      _getDifficultyText(recommendation.difficulty, isPortuguese),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
     .fadeIn()
     .slideY(begin: 0.3);
  }

  String _getExperienceLevelText(bool isPortuguese) {
    switch (_experienceLevel) {
      case 'beginner':
        return isPortuguese ? 'Iniciante' : 'Beginner';
      case 'intermediate':
        return isPortuguese ? 'Intermediário' : 'Intermediate';
      case 'expert':
        return isPortuguese ? 'Especialista' : 'Expert';
      default:
        return isPortuguese ? 'Iniciante' : 'Beginner';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'planting':
        return Icons.local_florist;
      case 'care':
        return Icons.favorite;
      case 'maintenance':
        return Icons.build;
      case 'harvest':
        return Icons.agriculture;
      default:
        return Icons.lightbulb;
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_very_satisfied;
      case 'medium':
        return Icons.sentiment_satisfied;
      case 'hard':
        return Icons.sentiment_neutral;
      default:
        return Icons.help_outline;
    }
  }

  String _getPriorityText(String priority, bool isPortuguese) {
    switch (priority.toLowerCase()) {
      case 'high':
        return isPortuguese ? 'Alta' : 'High';
      case 'medium':
        return isPortuguese ? 'Média' : 'Medium';
      case 'low':
        return isPortuguese ? 'Baixa' : 'Low';
      default:
        return isPortuguese ? 'Média' : 'Medium';
    }
  }

  String _getDifficultyText(String difficulty, bool isPortuguese) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return isPortuguese ? 'Fácil' : 'Easy';
      case 'medium':
        return isPortuguese ? 'Médio' : 'Medium';
      case 'hard':
        return isPortuguese ? 'Difícil' : 'Hard';
      default:
        return isPortuguese ? 'Médio' : 'Medium';
    }
  }
}