import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/responsive_builder.dart';
import '../../../shared/data/datasources/supabase_service.dart';
import '../../../shared/domain/entities/bed.dart';
import '../../../shared/domain/entities/crop.dart';
import '../../../shared/domain/entities/farm.dart';
import '../../../shared/domain/entities/planting.dart';
import '../../../shared/domain/entities/plot.dart';
import '../../ai_camera/screens/ai_camera_screen.dart';
import '../../ai_chat/screens/ai_chat_screen.dart';
import '../../tasks/screens/tasks_screen.dart';
import '../widgets/bed_editor_dialog.dart';
import '../widgets/garden_grid.dart';
import '../widgets/interactive_garden_grid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Farm? _currentFarm;
  Plot? _currentPlot;
  List<BedWithPlanting> _beds = [];
  bool _isLoading = true;
  String? _error;
  bool _useInteractiveEditor = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = SupabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load farms
      final farmsResponse = await SupabaseService.client
          .from('farms')
          .select()
          .eq('owner_id', userId);

      final farms =
          (farmsResponse as List).map((json) => Farm.fromJson(json)).toList();

      if (farms.isEmpty) {
        // User hasn't completed onboarding, redirect
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
        return;
      }

      // Load first farm's plot and beds
      final currentFarm = farms.first;

      final plotsResponse = await SupabaseService.client
          .from('plots')
          .select()
          .eq('farm_id', currentFarm.id)
          .limit(1)
          .single();

      final currentPlot = Plot.fromJson(plotsResponse);

      // Load beds with plantings and crops
      final bedsResponse = await SupabaseService.client.from('beds').select('''
            *,
            plantings(
              *,
              crops_catalog(*)
            )
          ''').eq('plot_id', currentPlot.id);

      final beds = (bedsResponse as List).map((bedJson) {
        final bed = Bed.fromJson(bedJson);
        Planting? planting;
        Crop? crop;

        if (bedJson['plantings'] != null &&
            (bedJson['plantings'] as List).isNotEmpty) {
          final plantingJson = (bedJson['plantings'] as List).first;
          planting = Planting.fromJson(plantingJson);

          if (plantingJson['crops_catalog'] != null) {
            crop = Crop.fromJson(plantingJson['crops_catalog']);
          }
        }

        return BedWithPlanting(
          bed: bed,
          planting: planting,
          crop: crop,
        );
      }).toList();

      setState(() {
        _currentFarm = currentFarm;
        _currentPlot = currentPlot;
        _beds = beds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  void _handleBedTapped(BedWithPlanting bedWithPlanting) {
    showDialog(
      context: context,
      builder: (context) => BedEditorDialog(
        bedWithPlanting: bedWithPlanting,
        onSave: (updatedBed, planting) async {
          await _refreshData();
        },
        onDelete: () async {
          await _refreshData();
        },
      ),
    );
  }

  void _handleAddBed(Offset position) {
    if (_currentPlot == null) return;

    const scale = 50.0;
    final gridX = (position.dx / scale);
    final gridY = (position.dy / scale);

    showDialog(
      context: context,
      builder: (context) => BedEditorDialog(
        bedWithPlanting: BedWithPlanting(
          bed: Bed(
            id: '',
            plotId: _currentPlot!.id,
            x: gridX.round(),
            y: gridY.round(),
            widthM: 1.2,
            heightM: 2.0,
            createdAt: DateTime.now(),
          ),
          planting: null,
          crop: null,
        ),
        onSave: (updatedBed, planting) async {
          await _refreshData();
        },
        onDelete: () async {
          await _refreshData();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (_isLoading) {
      return Scaffold(
        appBar:
            AppBar(title: Text(isPortuguese ? 'Carregando...' : 'Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(isPortuguese ? 'Erro' : 'Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                isPortuguese ? 'Erro ao carregar dados' : 'Error loading data',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _refreshData,
                child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return AdaptiveScaffold(
      appBar: AppBar(
        title: Text(
            _currentFarm?.name ?? (isPortuguese ? 'Minha Horta' : 'My Garden')),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: context.isMobile ? [
          IconButton(
            icon: Icon(_useInteractiveEditor ? Icons.edit : Icons.grid_view),
            onPressed: () {
              setState(() {
                _useInteractiveEditor = !_useInteractiveEditor;
              });
            },
            tooltip: _useInteractiveEditor 
                ? (isPortuguese ? 'Modo Visualização' : 'View Mode')
                : (isPortuguese ? 'Modo Edição' : 'Edit Mode'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'camera',
                child: ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(isPortuguese ? 'Reconhecer Planta' : 'Plant Recognition'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'chat',
                child: ListTile(
                  leading: const Icon(Icons.chat),
                  title: Text(isPortuguese ? 'Assistente IA' : 'AI Assistant'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'tasks',
                child: ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(isPortuguese ? 'Tarefas' : 'Tasks'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'camera':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AICameraScreen()),
                  );
                  break;
                case 'chat':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AIChatScreen()),
                  );
                  break;
                case 'tasks':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TasksScreen()),
                  );
                  break;
              }
            },
          ),
        ] : [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AICameraScreen()),
              );
            },
            tooltip: isPortuguese ? 'Reconhecer Planta' : 'Plant Recognition',
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIChatScreen()),
              );
            },
            tooltip: isPortuguese ? 'Assistente IA' : 'AI Assistant',
          ),
          IconButton(
            icon: Icon(_useInteractiveEditor ? Icons.edit : Icons.grid_view),
            onPressed: () {
              setState(() {
                _useInteractiveEditor = !_useInteractiveEditor;
              });
            },
            tooltip: _useInteractiveEditor 
                ? (isPortuguese ? 'Modo Visualização' : 'View Mode')
                : (isPortuguese ? 'Modo Edição' : 'Edit Mode'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status legend - responsive layout
          ResponsiveBuilder(
            builder: (context, screenSize) {
              return MobileOptimizedCard(
                child: screenSize == ScreenSize.mobile
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatusLegend(
                                  isPortuguese ? 'Saudável' : 'Healthy', Colors.green),
                              _buildStatusLegend(
                                  isPortuguese ? 'Atenção' : 'Warning', Colors.orange),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatusLegend(
                                  isPortuguese ? 'Crítico' : 'Critical', Colors.red),
                              _buildStatusLegend(
                                  isPortuguese ? 'Vazio' : 'Empty', Colors.grey),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatusLegend(
                              isPortuguese ? 'Saudável' : 'Healthy', Colors.green),
                          _buildStatusLegend(
                              isPortuguese ? 'Atenção' : 'Warning', Colors.orange),
                          _buildStatusLegend(
                              isPortuguese ? 'Crítico' : 'Critical', Colors.red),
                          _buildStatusLegend(
                              isPortuguese ? 'Vazio' : 'Empty', Colors.grey),
                        ],
                      ),
              );
            },
          ),

          // Map
          Expanded(
            child: _currentPlot == null
                ? Center(
                    child: Text(
                      isPortuguese
                          ? 'Nenhum canteiro encontrado'
                          : 'No beds found',
                    ),
                  )
                : _useInteractiveEditor
                    ? InteractiveGardenGrid(
                        plot: _currentPlot!,
                        beds: _beds,
                        onBedTapped: _handleBedTapped,
                        onAddBed: _handleAddBed,
                        onBedsUpdated: _refreshData,
                      )
                    : GardenGrid(
                        plot: _currentPlot!,
                        beds: _beds,
                        onBedTapped: _handleBedTapped,
                        onAddBed: _handleAddBed,
                      ),
          ),
        ],
      ),
      floatingActionButton: ResponsiveBuilder(
        builder: (context, screenSize) {
          if (screenSize == ScreenSize.mobile) {
            return FloatingActionButton(
              onPressed: () => _handleAddBed(const Offset(100, 100)),
              tooltip: isPortuguese ? 'Adicionar Canteiro' : 'Add Bed',
              child: const Icon(Icons.add),
            );
          } else {
            return FloatingActionButton.extended(
              onPressed: () => _handleAddBed(const Offset(100, 100)),
              icon: const Icon(Icons.add),
              label: Text(isPortuguese ? 'Canteiro' : 'Add Bed'),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final iconSize = context.responsiveValue(mobile: 16, tablet: 14, desktop: 12);
        final textSize = context.responsiveValue(mobile: 14, tablet: 13, desktop: 12);
        final spacing = context.responsiveValue(mobile: 8, tablet: 6, desktop: 4);
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: spacing),
            Text(
              label,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class BedWithPlanting {
  final Bed bed;
  final Planting? planting;
  final Crop? crop;

  BedWithPlanting({
    required this.bed,
    this.planting,
    this.crop,
  });
}

enum BedStatus {
  healthy,
  warning,
  critical,
  empty,
}