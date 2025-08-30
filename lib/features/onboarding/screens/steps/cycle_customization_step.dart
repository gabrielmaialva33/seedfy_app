import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../models/crop.dart';

class CycleCustomizationStep extends StatefulWidget {
  final List<Crop> selectedCrops;
  final Map<String, int> customCycles;
  final Function(Map<String, int>) onChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CycleCustomizationStep({
    Key? key,
    required this.selectedCrops,
    required this.customCycles,
    required this.onChanged,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<CycleCustomizationStep> createState() => _CycleCustomizationStepState();
}

class _CycleCustomizationStepState extends State<CycleCustomizationStep> {
  late Map<String, int> _customCycles;
  bool _useCustomCycles = false;

  @override
  void initState() {
    super.initState();
    _customCycles = Map.from(widget.customCycles);
    _useCustomCycles = _customCycles.isNotEmpty;
  }

  void _updateCycle(String cropId, int days) {
    setState(() {
      if (_useCustomCycles) {
        _customCycles[cropId] = days;
      } else {
        _customCycles.clear();
      }
    });
    widget.onChanged(_customCycles);
  }

  void _resetToDefaults() {
    setState(() {
      _customCycles.clear();
      _useCustomCycles = false;
    });
    widget.onChanged(_customCycles);
  }

  void _setOptimizedCycles() {
    setState(() {
      _useCustomCycles = true;
      // Set optimized cycles (20% faster than defaults for quick results)
      for (final crop in widget.selectedCrops) {
        _customCycles[crop.id] = (crop.cycleDays * 0.8).round();
      }
    });
    widget.onChanged(_customCycles);
  }

  int _getCycleDays(Crop crop) {
    return _customCycles[crop.id] ?? crop.cycleDays;
  }

  String _getCycleStatus(Crop crop) {
    final currentCycle = _getCycleDays(crop);
    final defaultCycle = crop.cycleDays;
    
    if (currentCycle == defaultCycle) {
      return 'Padrão';
    } else if (currentCycle < defaultCycle) {
      return 'Acelerado';
    } else {
      return 'Prolongado';
    }
  }

  Color _getCycleStatusColor(Crop crop) {
    final currentCycle = _getCycleDays(crop);
    final defaultCycle = crop.cycleDays;
    
    if (currentCycle == defaultCycle) {
      return Colors.blue;
    } else if (currentCycle < defaultCycle) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  DateTime _getEstimatedHarvestDate(Crop crop) {
    final cycleDays = _getCycleDays(crop);
    return DateTime.now().add(Duration(days: cycleDays));
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step title
          Text(
            isPortuguese ? 'Ciclos de Cultivo' : 'Growing Cycles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            isPortuguese 
              ? 'Personalize os ciclos de cultivo de acordo com suas condições locais (opcional)'
              : 'Customize growing cycles according to your local conditions (optional)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Toggle customization
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isPortuguese 
                          ? 'Personalizar ciclos de cultivo'
                          : 'Customize growing cycles',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: _useCustomCycles,
                      onChanged: (value) {
                        setState(() {
                          _useCustomCycles = value;
                          if (!value) {
                            _customCycles.clear();
                          } else {
                            // Initialize with default values
                            for (final crop in widget.selectedCrops) {
                              _customCycles[crop.id] = crop.cycleDays;
                            }
                          }
                        });
                        widget.onChanged(_customCycles);
                      },
                    ),
                  ],
                ),
                
                if (!_useCustomCycles) ...[
                  const SizedBox(height: 12),
                  Text(
                    isPortuguese 
                      ? 'Usando ciclos padrão recomendados'
                      : 'Using recommended standard cycles',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _resetToDefaults,
                          icon: const Icon(Icons.restore, size: 16),
                          label: Text(
                            isPortuguese ? 'Padrões' : 'Defaults',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _setOptimizedCycles,
                          icon: const Icon(Icons.speed, size: 16),
                          label: Text(
                            isPortuguese ? 'Otimizado' : 'Optimized',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Crop cycle list
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedCrops.length,
              itemBuilder: (context, index) {
                final crop = widget.selectedCrops[index];
                final currentCycle = _getCycleDays(crop);
                final harvestDate = _getEstimatedHarvestDate(crop);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.local_florist,
                                color: Colors.green[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    crop.getName(localeProvider.locale.languageCode),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getCycleStatusColor(crop).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isPortuguese 
                                            ? _getCycleStatus(crop)
                                            : _getCycleStatus(crop), // Translate if needed
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _getCycleStatusColor(crop),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isPortuguese 
                                          ? 'Padrão: ${crop.cycleDays} dias'
                                          : 'Default: ${crop.cycleDays} days',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        if (_useCustomCycles) ...[
                          const SizedBox(height: 16),
                          
                          // Cycle slider
                          Row(
                            children: [
                              Text(
                                isPortuguese ? 'Ciclo:' : 'Cycle:',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Slider(
                                  value: currentCycle.toDouble(),
                                  min: (crop.cycleDays * 0.5).roundToDouble(),
                                  max: (crop.cycleDays * 1.5).roundToDouble(),
                                  divisions: ((crop.cycleDays * 1.5) - (crop.cycleDays * 0.5)).round(),
                                  onChanged: (value) {
                                    _updateCycle(crop.id, value.round());
                                  },
                                ),
                              ),
                              Container(
                                width: 60,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$currentCycle${isPortuguese ? "d" : "d"}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                        ],
                        
                        // Harvest date estimate
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.green[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPortuguese 
                                  ? 'Colheita prevista: ${harvestDate.day}/${harvestDate.month}/${harvestDate.year}'
                                  : 'Expected harvest: ${harvestDate.month}/${harvestDate.day}/${harvestDate.year}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onPrevious,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back),
                        const SizedBox(width: 8),
                        Text(
                          isPortuguese ? 'Anterior' : 'Previous',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isPortuguese ? 'Próximo' : 'Next',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}