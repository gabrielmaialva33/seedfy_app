import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/crop.dart';
import '../../../models/planting.dart';
import '../screens/map_screen.dart';

class BedEditorDialog extends StatefulWidget {
  final BedWithPlanting bedWithPlanting;
  final Function(BedWithPlanting, Planting?) onSave;
  final VoidCallback onDelete;

  const BedEditorDialog({
    Key? key,
    required this.bedWithPlanting,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<BedEditorDialog> createState() => _BedEditorDialogState();
}

class _BedEditorDialogState extends State<BedEditorDialog> {
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _xController;
  late TextEditingController _yController;
  
  List<Crop> _availableCrops = [];
  Crop? _selectedCrop;
  DateTime _sowingDate = DateTime.now();
  int? _customCycleDays;
  bool _isLoading = false;
  bool _isLoadingCrops = true;
  String? _error;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    final bed = widget.bedWithPlanting.bed;
    _widthController = TextEditingController(text: bed.widthM.toString());
    _heightController = TextEditingController(text: bed.heightM.toString());
    _xController = TextEditingController(text: bed.x.toString());
    _yController = TextEditingController(text: bed.y.toString());
    
    _selectedCrop = widget.bedWithPlanting.crop;
    if (widget.bedWithPlanting.planting != null) {
      _sowingDate = widget.bedWithPlanting.planting!.sowingDate;
      _customCycleDays = widget.bedWithPlanting.planting!.customCycleDays;
    }
    
    _loadCrops();
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _xController.dispose();
    _yController.dispose();
    super.dispose();
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
        _isLoadingCrops = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingCrops = false;
      });
    }
  }

  Future<void> _saveBed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bed = widget.bedWithPlanting.bed;
      final updatedBed = bed.copyWith(
        widthM: double.parse(_widthController.text),
        heightM: double.parse(_heightController.text),
        x: int.parse(_xController.text),
        y: int.parse(_yController.text),
      );

      // Save or update bed
      if (bed.id.isEmpty) {
        // Create new bed
        final bedResponse = await SupabaseService.client
            .from('beds')
            .insert(updatedBed.toJson())
            .select()
            .single();
        
        final newBed = updatedBed.copyWith(id: bedResponse['id']);
        
        Planting? planting;
        if (_selectedCrop != null) {
          planting = await _createPlanting(newBed.id);
        }
        
        widget.onSave(BedWithPlanting(
          bed: newBed,
          planting: planting,
          crop: _selectedCrop,
        ), planting);
        
      } else {
        // Update existing bed
        await SupabaseService.client
            .from('beds')
            .update(updatedBed.toJson())
            .eq('id', bed.id);

        Planting? planting;
        if (_selectedCrop != null) {
          if (widget.bedWithPlanting.planting != null) {
            // Update existing planting
            planting = await _updatePlanting();
          } else {
            // Create new planting
            planting = await _createPlanting(bed.id);
          }
        } else if (widget.bedWithPlanting.planting != null) {
          // Delete existing planting
          await SupabaseService.client
              .from('plantings')
              .delete()
              .eq('id', widget.bedWithPlanting.planting!.id);
        }

        widget.onSave(BedWithPlanting(
          bed: updatedBed,
          planting: planting,
          crop: _selectedCrop,
        ), planting);
      }

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<Planting> _createPlanting(String bedId) async {
    final cycleDays = _customCycleDays ?? _selectedCrop!.cycleDays;
    final harvestDate = _sowingDate.add(Duration(days: cycleDays));
    
    final plantingData = {
      'bed_id': bedId,
      'crop_id': _selectedCrop!.id,
      'custom_cycle_days': _customCycleDays,
      'sowing_date': _sowingDate.toIso8601String().split('T')[0],
      'harvest_estimate': harvestDate.toIso8601String().split('T')[0],
      'quantity': _calculateQuantity(),
    };

    final response = await SupabaseService.client
        .from('plantings')
        .insert(plantingData)
        .select()
        .single();

    final planting = Planting.fromJson(response);
    
    // Create tasks for this planting
    await _createTasksForPlanting(planting.id, _sowingDate, cycleDays);
    
    return planting;
  }

  Future<Planting> _updatePlanting() async {
    final cycleDays = _customCycleDays ?? _selectedCrop!.cycleDays;
    final harvestDate = _sowingDate.add(Duration(days: cycleDays));
    
    final plantingData = {
      'crop_id': _selectedCrop!.id,
      'custom_cycle_days': _customCycleDays,
      'sowing_date': _sowingDate.toIso8601String().split('T')[0],
      'harvest_estimate': harvestDate.toIso8601String().split('T')[0],
      'quantity': _calculateQuantity(),
    };

    final response = await SupabaseService.client
        .from('plantings')
        .update(plantingData)
        .eq('id', widget.bedWithPlanting.planting!.id)
        .select()
        .single();

    return Planting.fromJson(response);
  }

  int _calculateQuantity() {
    if (_selectedCrop == null) return 0;
    
    final bedArea = double.parse(_widthController.text) * double.parse(_heightController.text);
    final plantArea = _selectedCrop!.rowSpacingM * _selectedCrop!.plantSpacingM;
    return (bedArea / plantArea).floor();
  }

  Future<void> _createTasksForPlanting(String plantingId, DateTime sowingDate, int cycleDays) async {
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

  Future<void> _deleteBed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este canteiro? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      
      try {
        await SupabaseService.client
            .from('beds')
            .delete()
            .eq('id', widget.bedWithPlanting.bed.id);
        
        widget.onDelete();
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';
    final isNewBed = widget.bedWithPlanting.bed.id.isEmpty;

    return AlertDialog(
      title: Text(isNewBed 
        ? (isPortuguese ? 'Novo Canteiro' : 'New Bed')
        : (isPortuguese ? 'Editar Canteiro' : 'Edit Bed')
      ),
      content: _isLoadingCrops
        ? const SizedBox(
            width: 300,
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        : _error != null
          ? SizedBox(
              width: 300,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    isPortuguese ? 'Erro ao carregar dados' : 'Error loading data',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_error!, textAlign: TextAlign.center),
                ],
              ),
            )
          : SizedBox(
              width: 400,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bed dimensions
                      Text(
                        isPortuguese ? 'Dimensões' : 'Dimensions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _widthController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: isPortuguese ? 'Largura (m)' : 'Width (m)',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isPortuguese ? 'Obrigatório' : 'Required';
                                }
                                final number = double.tryParse(value);
                                if (number == null || number <= 0) {
                                  return isPortuguese ? 'Valor inválido' : 'Invalid value';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: isPortuguese ? 'Altura (m)' : 'Height (m)',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isPortuguese ? 'Obrigatório' : 'Required';
                                }
                                final number = double.tryParse(value);
                                if (number == null || number <= 0) {
                                  return isPortuguese ? 'Valor inválido' : 'Invalid value';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Position
                      Text(
                        isPortuguese ? 'Posição' : 'Position',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _xController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'X',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isPortuguese ? 'Obrigatório' : 'Required';
                                }
                                final number = int.tryParse(value);
                                if (number == null) {
                                  return isPortuguese ? 'Valor inválido' : 'Invalid value';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _yController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Y',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isPortuguese ? 'Obrigatório' : 'Required';
                                }
                                final number = int.tryParse(value);
                                if (number == null) {
                                  return isPortuguese ? 'Valor inválido' : 'Invalid value';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Crop selection
                      Text(
                        isPortuguese ? 'Cultivo' : 'Crop',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<Crop>(
                        value: _selectedCrop,
                        decoration: InputDecoration(
                          labelText: isPortuguese ? 'Selecione uma cultura' : 'Select a crop',
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<Crop>(
                            value: null,
                            child: Text(isPortuguese ? 'Nenhuma (canteiro vazio)' : 'None (empty bed)'),
                          ),
                          ..._availableCrops.map((crop) => DropdownMenuItem(
                            value: crop,
                            child: Text(crop.getName(localeProvider.locale.languageCode)),
                          )),
                        ],
                        onChanged: (crop) {
                          setState(() {
                            _selectedCrop = crop;
                            _customCycleDays = null; // Reset custom cycle when crop changes
                          });
                        },
                      ),
                      
                      if (_selectedCrop != null) ...[
                        const SizedBox(height: 16),
                        
                        // Sowing date
                        ListTile(
                          title: Text(isPortuguese ? 'Data do plantio' : 'Sowing date'),
                          subtitle: Text(
                            '${_sowingDate.day}/${_sowingDate.month}/${_sowingDate.year}',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _sowingDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _sowingDate = date);
                            }
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Cycle customization
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isPortuguese 
                                  ? 'Ciclo: ${_customCycleDays ?? _selectedCrop!.cycleDays} dias'
                                  : 'Cycle: ${_customCycleDays ?? _selectedCrop!.cycleDays} days',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => _buildCycleCustomizationDialog(isPortuguese),
                                );
                              },
                              child: Text(isPortuguese ? 'Personalizar' : 'Customize'),
                            ),
                          ],
                        ),
                        
                        // Estimated quantity
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_florist,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPortuguese 
                                  ? 'Mudas estimadas: ${_calculateQuantity()}'
                                  : 'Estimated seedlings: ${_calculateQuantity()}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
      actions: [
        if (!isNewBed)
          TextButton(
            onPressed: _isLoading ? null : _deleteBed,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isPortuguese ? 'Excluir' : 'Delete'),
          ),
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(isPortuguese ? 'Cancelar' : 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveBed,
          child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(isPortuguese ? 'Salvar' : 'Save'),
        ),
      ],
    );
  }

  Widget _buildCycleCustomizationDialog(bool isPortuguese) {
    return AlertDialog(
      title: Text(isPortuguese ? 'Personalizar Ciclo' : 'Customize Cycle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPortuguese 
              ? 'Ciclo padrão: ${_selectedCrop!.cycleDays} dias'
              : 'Default cycle: ${_selectedCrop!.cycleDays} days',
          ),
          const SizedBox(height: 16),
          Slider(
            value: (_customCycleDays ?? _selectedCrop!.cycleDays).toDouble(),
            min: (_selectedCrop!.cycleDays * 0.5).roundToDouble(),
            max: (_selectedCrop!.cycleDays * 1.5).roundToDouble(),
            divisions: ((_selectedCrop!.cycleDays * 1.5) - (_selectedCrop!.cycleDays * 0.5)).round(),
            label: '${_customCycleDays ?? _selectedCrop!.cycleDays} ${isPortuguese ? "dias" : "days"}',
            onChanged: (value) {
              setState(() {
                _customCycleDays = value.round();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _customCycleDays = null);
            Navigator.pop(context);
          },
          child: Text(isPortuguese ? 'Padrão' : 'Default'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}