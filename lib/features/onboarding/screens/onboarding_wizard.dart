import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../models/crop.dart';
import '../../../services/supabase_service.dart';
import '../../../services/mongodb_service.dart';
import '../../../services/firebase_service.dart';
import 'steps/area_dimensions_step.dart';
import 'steps/path_configuration_step.dart';
import 'steps/crop_selection_step.dart';
import 'steps/cycle_customization_step.dart';
import 'steps/preview_step.dart';
import 'steps/approval_step.dart';
import '../../map/screens/map_screen.dart';

class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({Key? key}) : super(key: key);

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Onboarding data
  double _areaLength = 5.0;
  double _areaWidth = 3.0;
  double _pathGap = 0.4;
  List<Crop> _selectedCrops = [];
  Map<String, int> _customCycles = {};
  
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.profile?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create farm
      final farmResponse = await SupabaseService.client.from('farms').insert({
        'owner_id': userId,
        'name': 'Minha Horta', // Default farm name
      }).select().single();

      final farmId = farmResponse['id'];

      // Create plot
      final plotResponse = await SupabaseService.client.from('plots').insert({
        'farm_id': farmId,
        'label': 'Área Principal',
        'length_m': _areaLength,
        'width_m': _areaWidth,
        'path_gap_m': _pathGap,
      }).select().single();

      final plotId = plotResponse['id'];

      // Calculate bed layout
      final beds = _calculateBedLayout(plotId);
      
      // Create beds
      for (final bed in beds) {
        await SupabaseService.client.from('beds').insert(bed);
      }

      // Create plantings and tasks
      await _createPlantingsAndTasks(beds, plotId);

      // Navigate to map screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/map');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar horta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> _calculateBedLayout(String plotId) {
    // Calculate number of beds that fit
    final bedWidth = 1.2; // Standard bed width
    final bedLength = 2.0; // Standard bed length
    
    final bedsPerRow = (_areaWidth / (bedWidth + _pathGap)).floor();
    final bedsPerColumn = (_areaLength / (bedLength + _pathGap)).floor();
    
    final beds = <Map<String, dynamic>>[];
    
    for (int row = 0; row < bedsPerColumn; row++) {
      for (int col = 0; col < bedsPerRow; col++) {
        beds.add({
          'plot_id': plotId,
          'x': col,
          'y': row,
          'width_m': bedWidth,
          'height_m': bedLength,
        });
      }
    }
    
    return beds;
  }

  Future<void> _createPlantingsAndTasks(
      List<Map<String, dynamic>> beds, String plotId) async {
    if (_selectedCrops.isEmpty || beds.isEmpty) return;

    final now = DateTime.now();
    
    for (int i = 0; i < beds.length && i < _selectedCrops.length; i++) {
      final bedId = beds[i]['id'];
      final crop = _selectedCrops[i % _selectedCrops.length];
      final customCycle = _customCycles[crop.id] ?? crop.cycleDays;
      
      final harvestDate = now.add(Duration(days: customCycle));
      
      // Create planting
      final plantingResponse = await SupabaseService.client.from('plantings').insert({
        'bed_id': bedId,
        'crop_id': crop.id,
        'custom_cycle_days': customCycle != crop.cycleDays ? customCycle : null,
        'sowing_date': now.toIso8601String().split('T')[0],
        'harvest_estimate': harvestDate.toIso8601String().split('T')[0],
        'quantity': _calculateQuantity(crop, beds[i]),
      }).select().single();
      
      final plantingId = plantingResponse['id'];
      
      // Create tasks
      await _createTasksForPlanting(plantingId, now, customCycle);
    }
  }

  int _calculateQuantity(Crop crop, Map<String, dynamic> bed) {
    final bedArea = bed['width_m'] * bed['height_m'];
    final plantArea = crop.rowSpacingM * crop.plantSpacingM;
    return (bedArea / plantArea).floor();
  }

  Future<void> _createTasksForPlanting(
      String plantingId, DateTime sowingDate, int cycleDays) async {
    final tasks = [
      {
        'type': 'water',
        'due_date': sowingDate.add(const Duration(days: 1)),
      },
      {
        'type': 'fertilize',
        'due_date': sowingDate.add(Duration(days: (cycleDays * 0.3).round())),
      },
      {
        'type': 'transplant',
        'due_date': sowingDate.add(Duration(days: (cycleDays * 0.2).round())),
      },
      {
        'type': 'harvest',
        'due_date': sowingDate.add(Duration(days: cycleDays)),
      },
    ];

    for (final task in tasks) {
      await SupabaseService.client.from('tasks').insert({
        'planting_id': plantingId,
        'type': task['type'],
        'due_date': (task['due_date'] as DateTime).toIso8601String().split('T')[0],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPortuguese ? 'Configurar Horta' : 'Setup Garden'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= _currentStep
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index <= _currentStep
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Steps content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Area dimensions
                AreaDimensionsStep(
                  initialLength: _areaLength,
                  initialWidth: _areaWidth,
                  onChanged: (length, width) {
                    setState(() {
                      _areaLength = length;
                      _areaWidth = width;
                    });
                  },
                  onNext: _nextStep,
                ),
                
                // Step 2: Path configuration
                PathConfigurationStep(
                  initialPathGap: _pathGap,
                  areaLength: _areaLength,
                  areaWidth: _areaWidth,
                  onChanged: (pathGap) {
                    setState(() {
                      _pathGap = pathGap;
                    });
                  },
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                ),
                
                // Step 3: Crop selection
                CropSelectionStep(
                  selectedCrops: _selectedCrops,
                  onChanged: (crops) {
                    setState(() {
                      _selectedCrops = crops;
                    });
                  },
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                ),
                
                // Step 4: Cycle customization
                CycleCustomizationStep(
                  selectedCrops: _selectedCrops,
                  customCycles: _customCycles,
                  onChanged: (cycles) {
                    setState(() {
                      _customCycles = cycles;
                    });
                  },
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                ),
                
                // Step 5: Preview
                PreviewStep(
                  areaLength: _areaLength,
                  areaWidth: _areaWidth,
                  pathGap: _pathGap,
                  selectedCrops: _selectedCrops,
                  customCycles: _customCycles,
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                  onEdit: _goToStep,
                ),
                
                // Step 6: Approval
                ApprovalStep(
                  onApprove: _completeOnboarding,
                  onPrevious: _previousStep,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}