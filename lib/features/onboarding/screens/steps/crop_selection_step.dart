import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../models/crop.dart';
import '../../../../services/supabase_service.dart';

class CropSelectionStep extends StatefulWidget {
  final List<Crop> selectedCrops;
  final Function(List<Crop>) onChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CropSelectionStep({
    Key? key,
    required this.selectedCrops,
    required this.onChanged,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<CropSelectionStep> createState() => _CropSelectionStepState();
}

class _CropSelectionStepState extends State<CropSelectionStep> {
  List<Crop> _availableCrops = [];
  List<Crop> _selectedCrops = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedCrops = List.from(widget.selectedCrops);
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    try {
      final response = await SupabaseService.client
          .from('crops_catalog')
          .select()
          .order('name_pt');

      final crops = (response as List)
          .map((json) => Crop.fromJson(json))
          .toList();

      setState(() {
        _availableCrops = crops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleCrop(Crop crop) {
    setState(() {
      if (_selectedCrops.contains(crop)) {
        _selectedCrops.remove(crop);
      } else {
        _selectedCrops.add(crop);
      }
    });
    widget.onChanged(_selectedCrops);
  }

  bool _isCropSelected(Crop crop) {
    return _selectedCrops.any((selected) => selected.id == crop.id);
  }

  void _selectRecommendedCrops() {
    final recommended = _availableCrops.where((crop) => 
      ['Alface', 'Rúcula', 'Espinafre', 'Rabanete', 'Couve']
          .contains(crop.namePt)
    ).toList();
    
    setState(() {
      _selectedCrops = recommended;
    });
    widget.onChanged(_selectedCrops);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              isPortuguese ? 'Erro ao carregar culturas' : 'Error loading crops',
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
              onPressed: _loadCrops,
              child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step title
          Text(
            isPortuguese ? 'Seleção de Culturas' : 'Crop Selection',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            isPortuguese 
              ? 'Escolha as hortaliças que deseja cultivar. Você pode selecionar múltiplas culturas.'
              : 'Choose the vegetables you want to grow. You can select multiple crops.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Selection summary and quick actions
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
                    Text(
                      isPortuguese 
                        ? 'Selecionadas: ${_selectedCrops.length}'
                        : 'Selected: ${_selectedCrops.length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (_selectedCrops.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedCrops.clear();
                          });
                          widget.onChanged(_selectedCrops);
                        },
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: Text(
                          isPortuguese ? 'Limpar' : 'Clear',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                  ],
                ),
                
                if (_selectedCrops.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _selectRecommendedCrops,
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: Text(
                          isPortuguese ? 'Seleção Recomendada' : 'Recommended Selection',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Crop gallery
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _availableCrops.length,
              itemBuilder: (context, index) {
                final crop = _availableCrops[index];
                final isSelected = _isCropSelected(crop);
                
                return GestureDetector(
                  onTap: () => _toggleCrop(crop),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image section
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getCropIcon(crop.namePt),
                                      size: 32,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Info section
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  crop.getName(localeProvider.locale.languageCode),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${crop.cycleDays} ${isPortuguese ? "dias" : "days"}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.straighten,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${crop.plantSpacingM}m',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                  onPressed: _selectedCrops.isNotEmpty ? widget.onNext : null,
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

  IconData _getCropIcon(String cropName) {
    switch (cropName.toLowerCase()) {
      case 'alface':
        return Icons.local_florist;
      case 'tomate':
        return Icons.circle;
      case 'cenoura':
        return Icons.grain;
      case 'couve':
        return Icons.eco;
      case 'rúcula':
        return Icons.local_florist;
      case 'espinafre':
        return Icons.eco;
      case 'rabanete':
        return Icons.circle_outlined;
      case 'brócolis':
        return Icons.park;
      default:
        return Icons.local_florist;
    }
  }
}