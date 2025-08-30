import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../models/crop.dart';

class PreviewStep extends StatelessWidget {
  final double areaLength;
  final double areaWidth;
  final double pathGap;
  final List<Crop> selectedCrops;
  final Map<String, int> customCycles;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int) onEdit;

  const PreviewStep({
    Key? key,
    required this.areaLength,
    required this.areaWidth,
    required this.pathGap,
    required this.selectedCrops,
    required this.customCycles,
    required this.onNext,
    required this.onPrevious,
    required this.onEdit,
  }) : super(key: key);

  int get _estimatedBeds {
    const bedWidth = 1.2;
    const bedLength = 2.0;
    
    final bedsPerRow = (areaWidth / (bedWidth + pathGap)).floor();
    final bedsPerColumn = (areaLength / (bedLength + pathGap)).floor();
    
    return bedsPerRow * bedsPerColumn;
  }

  int _getTotalPlants() {
    int total = 0;
    final bedsPerCrop = (_estimatedBeds / selectedCrops.length).ceil();
    
    for (final crop in selectedCrops) {
      const bedArea = 1.2 * 2.0; // Standard bed size
      final plantArea = crop.rowSpacingM * crop.plantSpacingM;
      final plantsPerBed = (bedArea / plantArea).floor();
      total += plantsPerBed * bedsPerCrop;
    }
    
    return total;
  }

  int _getCycleDays(Crop crop) {
    return customCycles[crop.id] ?? crop.cycleDays;
  }

  DateTime _getEarliestHarvest() {
    if (selectedCrops.isEmpty) return DateTime.now();
    
    final shortestCycle = selectedCrops
        .map((crop) => _getCycleDays(crop))
        .reduce((a, b) => a < b ? a : b);
    
    return DateTime.now().add(Duration(days: shortestCycle));
  }

  DateTime _getLatestHarvest() {
    if (selectedCrops.isEmpty) return DateTime.now();
    
    final longestCycle = selectedCrops
        .map((crop) => _getCycleDays(crop))
        .reduce((a, b) => a > b ? a : b);
    
    return DateTime.now().add(Duration(days: longestCycle));
  }

  String _formatDate(DateTime date, bool isPortuguese) {
    return isPortuguese 
      ? '${date.day}/${date.month}/${date.year}'
      : '${date.month}/${date.day}/${date.year}';
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
            isPortuguese ? 'Preview da Horta' : 'Garden Preview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            isPortuguese 
              ? 'Revise sua configuração antes de criar a horta. Você pode voltar e editar qualquer passo.'
              : 'Review your setup before creating the garden. You can go back and edit any step.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView(
              children: [
                // Area summary
                _buildSummaryCard(
                  context,
                  title: isPortuguese ? 'Dimensões da Área' : 'Area Dimensions',
                  icon: Icons.crop_landscape,
                  onEdit: () => onEdit(0),
                  children: [
                    _buildInfoRow(
                      isPortuguese ? 'Comprimento:' : 'Length:',
                      '${areaLength.toStringAsFixed(1)}m',
                    ),
                    _buildInfoRow(
                      isPortuguese ? 'Largura:' : 'Width:',
                      '${areaWidth.toStringAsFixed(1)}m',
                    ),
                    _buildInfoRow(
                      isPortuguese ? 'Área total:' : 'Total area:',
                      '${(areaLength * areaWidth).toStringAsFixed(1)} m²',
                      isHighlighted: true,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Path configuration
                _buildSummaryCard(
                  context,
                  title: isPortuguese ? 'Configuração dos Caminhos' : 'Path Configuration',
                  icon: Icons.linear_scale,
                  onEdit: () => onEdit(1),
                  children: [
                    _buildInfoRow(
                      isPortuguese ? 'Largura dos corredores:' : 'Corridor width:',
                      '${pathGap.toStringAsFixed(1)}m',
                    ),
                    _buildInfoRow(
                      isPortuguese ? 'Canteiros estimados:' : 'Estimated beds:',
                      '$_estimatedBeds',
                      isHighlighted: true,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Selected crops
                _buildSummaryCard(
                  context,
                  title: isPortuguese 
                    ? 'Culturas Selecionadas (${selectedCrops.length})'
                    : 'Selected Crops (${selectedCrops.length})',
                  icon: Icons.local_florist,
                  onEdit: () => onEdit(2),
                  children: [
                    ...selectedCrops.map((crop) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_florist,
                              color: Colors.green[700],
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              crop.getName(localeProvider.locale.languageCode),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_getCycleDays(crop)} ${isPortuguese ? "dias" : "days"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Growing timeline
                _buildSummaryCard(
                  context,
                  title: isPortuguese ? 'Cronograma de Cultivo' : 'Growing Timeline',
                  icon: Icons.schedule,
                  onEdit: () => onEdit(3),
                  children: [
                    _buildInfoRow(
                      isPortuguese ? 'Primeira colheita:' : 'First harvest:',
                      _formatDate(_getEarliestHarvest(), isPortuguese),
                    ),
                    _buildInfoRow(
                      isPortuguese ? 'Última colheita:' : 'Last harvest:',
                      _formatDate(_getLatestHarvest(), isPortuguese),
                    ),
                    _buildInfoRow(
                      isPortuguese ? 'Plantas estimadas:' : 'Estimated plants:',
                      '${_getTotalPlants()} ${isPortuguese ? "mudas" : "seedlings"}',
                      isHighlighted: true,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Interactive map preview
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: CustomPaint(
                            painter: GardenPreviewPainter(
                              areaLength: areaLength,
                              areaWidth: areaWidth,
                              pathGap: pathGap,
                              bedCount: _estimatedBeds,
                              selectedCrops: selectedCrops,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isPortuguese ? 'Preview da Distribuição' : 'Layout Preview',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isPortuguese ? 'Dicas' : 'Tips',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isPortuguese 
                          ? '• O sistema irá criar automaticamente tarefas como regar, adubar e colher\n• Você poderá editar o mapa e reorganizar as culturas após a criação\n• As datas de colheita são estimativas baseadas nos ciclos padrão'
                          : '• The system will automatically create tasks like watering, fertilizing and harvesting\n• You can edit the map and reorganize crops after creation\n• Harvest dates are estimates based on standard cycles',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrevious,
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
                  onPressed: onNext,
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
                          isPortuguese ? 'Criar Horta' : 'Create Garden',
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

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHighlighted ? Colors.black : Colors.grey[600],
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class GardenPreviewPainter extends CustomPainter {
  final double areaLength;
  final double areaWidth;
  final double pathGap;
  final int bedCount;
  final List<Crop> selectedCrops;

  GardenPreviewPainter({
    required this.areaLength,
    required this.areaWidth,
    required this.pathGap,
    required this.bedCount,
    required this.selectedCrops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.brown[300]!
      ..style = PaintingStyle.fill;
    
    final bedPaint = Paint()
      ..color = Colors.green[300]!
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.green[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw background (paths)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pathPaint,
    );
    
    // Calculate bed layout
    const bedWidth = 20.0;
    const bedHeight = 15.0;
    final gapSize = (pathGap * 10).clamp(4.0, 15.0); // Scale for visualization
    
    final bedsPerRow = ((size.width - gapSize) / (bedWidth + gapSize)).floor();
    final bedsPerColumn = ((size.height - gapSize) / (bedHeight + gapSize)).floor();
    
    // Draw beds with crop colors
    int bedIndex = 0;
    for (int row = 0; row < bedsPerColumn; row++) {
      for (int col = 0; col < bedsPerRow; col++) {
        final x = gapSize + col * (bedWidth + gapSize);
        final y = gapSize + row * (bedHeight + gapSize);
        
        // Assign crop color if we have crops
        if (selectedCrops.isNotEmpty) {
          final cropIndex = bedIndex % selectedCrops.length;
          bedPaint.color = _getCropColor(cropIndex);
        }
        
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, bedWidth, bedHeight),
            const Radius.circular(2),
          ),
          bedPaint,
        );
        
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, bedWidth, bedHeight),
            const Radius.circular(2),
          ),
          borderPaint,
        );
        
        bedIndex++;
      }
    }
  }

  Color _getCropColor(int index) {
    final colors = [
      Colors.green[300]!,
      Colors.blue[300]!,
      Colors.orange[300]!,
      Colors.purple[300]!,
      Colors.teal[300]!,
      Colors.pink[300]!,
      Colors.indigo[300]!,
      Colors.amber[300]!,
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}