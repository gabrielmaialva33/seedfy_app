import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/locale_provider.dart';

class AreaDimensionsStep extends StatefulWidget {
  final double initialLength;
  final double initialWidth;
  final Function(double length, double width) onChanged;
  final VoidCallback onNext;

  const AreaDimensionsStep({
    Key? key,
    required this.initialLength,
    required this.initialWidth,
    required this.onChanged,
    required this.onNext,
  }) : super(key: key);

  @override
  State<AreaDimensionsStep> createState() => _AreaDimensionsStepState();
}

class _AreaDimensionsStepState extends State<AreaDimensionsStep> {
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _lengthController = TextEditingController(text: widget.initialLength.toString());
    _widthController = TextEditingController(text: widget.initialWidth.toString());
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  void _updateValues() {
    final length = double.tryParse(_lengthController.text) ?? widget.initialLength;
    final width = double.tryParse(_widthController.text) ?? widget.initialWidth;
    widget.onChanged(length, width);
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      _updateValues();
      widget.onNext();
    }
  }

  double get _totalArea {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    return length * width;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step title
            Text(
              isPortuguese ? 'Dimensões da Área' : 'Area Dimensions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              isPortuguese 
                ? 'Informe as dimensões da sua área de cultivo em metros'
                : 'Enter your cultivation area dimensions in meters',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Visual representation
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Stack(
                children: [
                  // Area rectangle
                  Center(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        border: Border.all(color: Colors.green[400]!, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Length indicator
                  Positioned(
                    top: 20,
                    left: 50,
                    right: 50,
                    child: Container(
                      height: 2,
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 0,
                    right: 0,
                    child: Text(
                      '${_lengthController.text}m',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Width indicator
                  Positioned(
                    left: 20,
                    top: 50,
                    bottom: 50,
                    child: Container(
                      width: 2,
                      color: Colors.orange,
                      child: Column(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          '${_widthController.text}m',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Length input
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lengthController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: isPortuguese ? 'Comprimento (m)' : 'Length (m)',
                      hintText: '5.0',
                      prefixIcon: const Icon(Icons.straighten),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixText: 'm',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isPortuguese ? 'Obrigatório' : 'Required';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return isPortuguese ? 'Valor inválido' : 'Invalid value';
                      }
                      if (number > 100) {
                        return isPortuguese ? 'Máximo 100m' : 'Maximum 100m';
                      }
                      return null;
                    },
                    onChanged: (_) {
                      setState(() {}); // Rebuild to update visual and area
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Width input
                Expanded(
                  child: TextFormField(
                    controller: _widthController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: isPortuguese ? 'Largura (m)' : 'Width (m)',
                      hintText: '3.0',
                      prefixIcon: const Icon(Icons.straighten, 
                        textDirection: TextDirection.ltr),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixText: 'm',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isPortuguese ? 'Obrigatório' : 'Required';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return isPortuguese ? 'Valor inválido' : 'Invalid value';
                      }
                      if (number > 100) {
                        return isPortuguese ? 'Máximo 100m' : 'Maximum 100m';
                      }
                      return null;
                    },
                    onChanged: (_) {
                      setState(() {}); // Rebuild to update visual and area
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Total area display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.crop_landscape,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPortuguese 
                      ? 'Área total: ${_totalArea.toStringAsFixed(1)} m²'
                      : 'Total area: ${_totalArea.toStringAsFixed(1)} m²',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Next button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}