import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/farm.dart';
import '../../../models/plot.dart';
import '../../../models/bed.dart';
import '../../../models/planting.dart';
import '../../../models/crop.dart';
import '../widgets/garden_grid_enhanced.dart';
import '../widgets/bed_editor_dialog.dart';
import '../../ai_camera/screens/camera_screen.dart';
import '../../ai_chat/screens/chat_screen.dart';
import '../../tasks/screens/tasks_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Farm> _farms = [];
  Farm? _currentFarm;
  Plot? _currentPlot;
  List<BedWithPlanting> _beds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.profile?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load farms
      final farmsResponse = await SupabaseService.client
          .from('farms')
          .select()
          .eq('owner_id', userId);
      
      final farms = (farmsResponse as List)
          .map((json) => Farm.fromJson(json))
          .toList();

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
      final bedsResponse = await SupabaseService.client
          .from('beds')
          .select('''
            *,
            plantings(
              *,
              crops_catalog(*)
            )
          ''')
          .eq('plot_id', currentPlot.id);
      
      final beds = (bedsResponse as List).map((bedJson) {
        final bed = Bed.fromJson(bedJson);
        Planting? planting;
        Crop? crop;
        
        if (bedJson['plantings'] != null && (bedJson['plantings'] as List).isNotEmpty) {
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
        _farms = farms;
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

  BedStatus _getBedStatus(BedWithPlanting bedWithPlanting) {
    if (bedWithPlanting.planting == null || bedWithPlanting.crop == null) {
      return BedStatus.empty;
    }
    
    final now = DateTime.now();
    final harvestDate = bedWithPlanting.planting!.harvestEstimate;
    final daysUntilHarvest = harvestDate.difference(now).inDays;
    
    if (daysUntilHarvest < 0) {
      return BedStatus.critical; // Overdue
    } else if (daysUntilHarvest <= 7) {
      return BedStatus.warning; // Soon to harvest
    } else {
      return BedStatus.healthy; // Growing well
    }
  }

  void _exportToCsv() async {
    try {
      final localeProvider = context.read<LocaleProvider>();
      final isPortuguese = localeProvider.locale.languageCode == 'pt';
      
      final csvData = StringBuffer();
      
      // CSV Header
      if (isPortuguese) {
        csvData.writeln('Canteiro,Posição X,Posição Y,Largura (m),Altura (m),Área (m²),Cultura,Data Plantio,Previsão Colheita,Status');
      } else {
        csvData.writeln('Bed,Position X,Position Y,Width (m),Height (m),Area (m²),Crop,Planting Date,Harvest Date,Status');
      }
      
      // CSV Data
      for (final bedWithPlanting in _beds) {
        final bed = bedWithPlanting.bed;
        final planting = bedWithPlanting.planting;
        final crop = bedWithPlanting.crop;
        
        csvData.writeln([
          bed.id,
          bed.x,
          bed.y,
          bed.widthM,
          bed.heightM,
          (bed.widthM * bed.heightM).toStringAsFixed(2),
          crop?.getName(localeProvider.locale.languageCode) ?? (isPortuguese ? 'Vazio' : 'Empty'),
          planting?.sowingDate.toIso8601String().split('T')[0] ?? '',
          planting?.harvestEstimate.toIso8601String().split('T')[0] ?? '',
          _getStatusText(_getBedStatus(bedWithPlanting), isPortuguese),
        ].join(','));
      }
      
      // Show CSV preview
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(isPortuguese ? 'Dados CSV' : 'CSV Data'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: SingleChildScrollView(
              child: SelectableText(
                csvData.toString(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isPortuguese ? 'Fechar' : 'Close'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar CSV: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getStatusText(BedStatus status, bool isPortuguese) {
    switch (status) {
      case BedStatus.healthy:
        return isPortuguese ? 'Saudável' : 'Healthy';
      case BedStatus.warning:
        return isPortuguese ? 'Atenção' : 'Warning';
      case BedStatus.critical:
        return isPortuguese ? 'Crítico' : 'Critical';
      case BedStatus.empty:
        return isPortuguese ? 'Vazio' : 'Empty';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(isPortuguese ? 'Carregando...' : 'Loading...')),
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
                onPressed: _refreshData,
                child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFarm?.name ?? (isPortuguese ? 'Minha Horta' : 'My Garden')),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
            tooltip: isPortuguese ? 'Reconhecer Planta' : 'Plant Recognition',
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            tooltip: isPortuguese ? 'Assistente IA' : 'AI Assistant',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'tasks',
                child: Row(
                  children: [
                    const Icon(Icons.task_alt),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Tarefas' : 'Tasks'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.download),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Exportar CSV' : 'Export CSV'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Atualizar' : 'Refresh'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text(isPortuguese ? 'Sair' : 'Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'tasks':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TasksScreen()),
                  );
                  break;
                case 'export':
                  _exportToCsv();
                  break;
                case 'refresh':
                  _refreshData();
                  break;
                case 'logout':
                  context.read<AuthProvider>().signOut();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status legend
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              children: [
                _buildStatusLegend(
                  isPortuguese ? 'Saudável' : 'Healthy', 
                  Colors.green
                ),
                const SizedBox(width: 16),
                _buildStatusLegend(
                  isPortuguese ? 'Atenção' : 'Warning', 
                  Colors.orange
                ),
                const SizedBox(width: 16),
                _buildStatusLegend(
                  isPortuguese ? 'Crítico' : 'Critical', 
                  Colors.red
                ),
                const SizedBox(width: 16),
                _buildStatusLegend(
                  isPortuguese ? 'Vazio' : 'Empty', 
                  Colors.grey
                ),
              ],
            ),
          ),
          
          // Map
          Expanded(
            child: _currentPlot == null 
              ? Center(
                  child: Text(
                    isPortuguese ? 'Nenhum canteiro encontrado' : 'No beds found',
                  ),
                )
              : GardenGridEnhanced(
                  plot: _currentPlot!,
                  beds: _beds,
                  onBedTapped: _handleBedTapped,
                  onAddBed: _handleAddBed,
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleAddBed(const Offset(100, 100)),
        icon: const Icon(Icons.add),
        label: Text(isPortuguese ? 'Canteiro' : 'Add Bed'),
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
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