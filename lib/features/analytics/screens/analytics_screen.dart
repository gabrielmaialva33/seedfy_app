import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/domain/entities/planting.dart';
import '../../../shared/domain/entities/task.dart';
import '../../../shared/data/datasources/supabase_service.dart';

class AnalyticsData {
  final int totalPlants;
  final int readyToHarvest;
  final int activeTasks;
  final double averageGrowthDays;
  final List<PlantGrowthData> growthData;
  final List<HarvestPrediction> harvestPredictions;

  AnalyticsData({
    required this.totalPlants,
    required this.readyToHarvest,
    required this.activeTasks,
    required this.averageGrowthDays,
    required this.growthData,
    required this.harvestPredictions,
  });
}

class PlantGrowthData {
  final String month;
  final int plantCount;

  PlantGrowthData({required this.month, required this.plantCount});
}

class HarvestPrediction {
  final String cropName;
  final int daysToHarvest;
  final int quantity;

  HarvestPrediction({
    required this.cropName,
    required this.daysToHarvest,
    required this.quantity,
  });
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsData? _analyticsData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final authProvider = context.read<AuthBloc>();
      final userId = authProvider.profile?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load plantings data
      final plantingsResponse =
          await SupabaseService.client.from('plantings').select('''
            *,
            crops_catalog(*),
            beds(plots(farms!inner(owner_id)))
          ''').eq('beds.plots.farms.owner_id', userId);

      // Load tasks data
      final tasksResponse = await SupabaseService.client
          .from('tasks')
          .select('''
            *,
            plantings(beds(plots(farms!inner(owner_id))))
          ''')
          .eq('plantings.beds.plots.farms.owner_id', userId)
          .eq('done', false);

      final plantings = (plantingsResponse as List)
          .map((json) => Planting.fromJson(json))
          .toList();

      final tasks = (tasksResponse as List)
          .map((json) => GardenTask.fromJson(json))
          .toList();

      // Calculate analytics
      final totalPlants = plantings.length;
      final readyToHarvest = plantings.where((p) {
        final daysSincePlanting =
            DateTime.now().difference(p.sowingDate).inDays;
        return daysSincePlanting >= 60; // Simplified logic
      }).length;

      final activeTasks = tasks.length;

      final averageGrowthDays = plantings.isNotEmpty
          ? plantings
                  .map((p) => DateTime.now().difference(p.sowingDate).inDays)
                  .reduce((a, b) => a + b) /
              plantings.length
          : 0.0;

      // Generate mock growth data for chart
      final growthData = _generateGrowthData(plantings);
      final harvestPredictions = _generateHarvestPredictions(plantings);

      setState(() {
        _analyticsData = AnalyticsData(
          totalPlants: totalPlants,
          readyToHarvest: readyToHarvest,
          activeTasks: activeTasks,
          averageGrowthDays: averageGrowthDays,
          growthData: growthData,
          harvestPredictions: harvestPredictions,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<PlantGrowthData> _generateGrowthData(List<Planting> plantings) {
    final Map<int, int> monthlyData = {};
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      monthlyData[month.month] = 0;
    }

    for (final planting in plantings) {
      final month = planting.sowingDate.month;
      if (monthlyData.containsKey(month)) {
        monthlyData[month] = monthlyData[month]! + 1;
      }
    }

    return monthlyData.entries.map((entry) {
      final monthNames = [
        'Jan',
        'Fev',
        'Mar',
        'Abr',
        'Mai',
        'Jun',
        'Jul',
        'Ago',
        'Set',
        'Out',
        'Nov',
        'Dez'
      ];
      return PlantGrowthData(
        month: monthNames[entry.key - 1],
        plantCount: entry.value,
      );
    }).toList();
  }

  List<HarvestPrediction> _generateHarvestPredictions(
      List<Planting> plantings) {
    return plantings.take(5).map((planting) {
      final daysSincePlanting =
          DateTime.now().difference(planting.sowingDate).inDays;
      final daysToHarvest = (75 - daysSincePlanting).clamp(0, 75);

      return HarvestPrediction(
        cropName: 'Planta ${planting.id.substring(0, 6)}',
        daysToHarvest: daysToHarvest,
        quantity: 1,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(isPortuguese ? 'Análises' : 'Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(isPortuguese)
              : _buildAnalyticsContent(isPortuguese),
    );
  }

  Widget _buildErrorState(bool isPortuguese) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            isPortuguese
                ? 'Erro ao carregar análises'
                : 'Error loading analytics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadAnalyticsData,
            child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(bool isPortuguese) {
    if (_analyticsData == null) {
      return Center(
        child: Text(
          isPortuguese ? 'Sem dados disponíveis' : 'No data available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnalyticsData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsCards(isPortuguese),
            const SizedBox(height: 24),
            _buildGrowthChart(isPortuguese),
            const SizedBox(height: 24),
            _buildHarvestPredictions(isPortuguese),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards(bool isPortuguese) {
    final metrics = [
      {
        'title': isPortuguese ? 'Total de Plantas' : 'Total Plants',
        'value': '${_analyticsData!.totalPlants}',
        'icon': Icons.eco,
        'color': AppTheme.primaryGreen,
      },
      {
        'title': isPortuguese ? 'Prontas para Colher' : 'Ready to Harvest',
        'value': '${_analyticsData!.readyToHarvest}',
        'icon': Icons.agriculture,
        'color': AppTheme.accentOrange,
      },
      {
        'title': isPortuguese ? 'Tarefas Ativas' : 'Active Tasks',
        'value': '${_analyticsData!.activeTasks}',
        'icon': Icons.assignment,
        'color': AppTheme.primaryPurple,
      },
      {
        'title': isPortuguese ? 'Crescimento Médio' : 'Average Growth',
        'value': '${_analyticsData!.averageGrowthDays.toInt()} dias',
        'icon': Icons.trending_up,
        'color': AppTheme.successGreen,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (metric['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      metric['icon'] as IconData,
                      color: metric['color'] as Color,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                metric['value'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric['title'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrowthChart(bool isPortuguese) {
    if (_analyticsData!.growthData.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Center(
          child: Text(
            isPortuguese ? 'Sem dados disponíveis' : 'No data available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPortuguese ? 'Crescimento das Plantas' : 'Plant Growth',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _analyticsData!.growthData
                        .map((e) => e.plantCount.toDouble())
                        .reduce((a, b) => a > b ? a : b) +
                    2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppTheme.primaryPurple,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index >= 0 &&
                            index < _analyticsData!.growthData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _analyticsData!.growthData[index].month,
                              style: const TextStyle(
                                color: AppTheme.textGray,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: AppTheme.textGray,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    _analyticsData!.growthData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.plantCount.toDouble(),
                        gradient: AppTheme.primaryGradient,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestPredictions(bool isPortuguese) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPortuguese ? 'Previsão de Colheita' : 'Harvest Prediction',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          if (_analyticsData!.harvestPredictions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  isPortuguese ? 'Sem dados disponíveis' : 'No data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...(_analyticsData!.harvestPredictions.map((prediction) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.cropName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            prediction.daysToHarvest == 0
                                ? (isPortuguese
                                    ? 'Pronto para colher!'
                                    : 'Ready to harvest!')
                                : isPortuguese
                                    ? 'Pronto em ${prediction.daysToHarvest} dias'
                                    : 'Ready in ${prediction.daysToHarvest} days',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: prediction.daysToHarvest <= 7
                            ? AppTheme.accentOrange.withValues(alpha: 0.1)
                            : AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prediction.daysToHarvest <= 7
                            ? (isPortuguese ? 'Em breve' : 'Soon')
                            : (isPortuguese ? 'Crescendo' : 'Growing'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: prediction.daysToHarvest <= 7
                              ? AppTheme.accentOrange
                              : AppTheme.successGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
        ],
      ),
    );
  }
}
