import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/locale_provider.dart';

class PathConfigurationStep extends StatefulWidget {
  final double initialPathGap;
  final double areaLength;
  final double areaWidth;
  final Function(double pathGap) onChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PathConfigurationStep({
    Key? key,
    required this.initialPathGap,
    required this.areaLength,
    required this.areaWidth,
    required this.onChanged,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<PathConfigurationStep> createState() => _PathConfigurationStepState();
}

class _PathConfigurationStepState extends State<PathConfigurationStep> {
  late double _pathGap;
  
  @override
  void initState() {
    super.initState();
    _pathGap = widget.initialPathGap;
  }

  void _updatePathGap(double value) {
    setState(() {
      _pathGap = value;
    });
    widget.onChanged(value);
  }

  int get _estimatedBeds {
    const bedWidth = 1.2;
    const bedLength = 2.0;
    
    final bedsPerRow = (widget.areaWidth / (bedWidth + _pathGap)).floor();
    final bedsPerColumn = (widget.areaLength / (bedLength + _pathGap)).floor();
    
    return bedsPerRow * bedsPerColumn;
  }

  double get _cultivableArea {
    const bedWidth = 1.2;
    const bedLength = 2.0;
    
    return _estimatedBeds * bedWidth * bedLength;
  }

  double get _pathArea {
    return (widget.areaLength * widget.areaWidth) - _cultivableArea;
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
            isPortuguese ? 'Caminhos entre Canteiros' : 'Paths Between Beds',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            isPortuguese 
              ? 'Configure a largura dos corredores para circulação entre os canteiros'
              : 'Configure the width of corridors for circulation between beds',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Visual representation with grid
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: BedLayoutPainter(
                  pathGap: _pathGap,
                  bedCount: _estimatedBeds,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Path gap slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPortuguese ? 'Largura do corredor:' : 'Corridor width:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_pathGap.toStringAsFixed(1)}m',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Slider(
                    value: _pathGap,
                    min: 0.2,
                    max: 1.0,
                    divisions: 8,
                    onChanged: _updatePathGap,
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.2m', style: TextStyle(color: Colors.grey[600])),
                      Text('1.0m', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick preset buttons
          Text(
            isPortuguese ? 'Sugestões:' : 'Suggestions:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updatePathGap(0.3),
                  child: Column(
                    children: [
                      const Icon(Icons.directions_walk, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        isPortuguese ? 'Estreito\n0.3m' : 'Narrow\n0.3m',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updatePathGap(0.4),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _pathGap == 0.4 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[400]!,
                      width: _pathGap == 0.4 ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.accessibility_new, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        isPortuguese ? 'Padrão\n0.4m' : 'Standard\n0.4m',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updatePathGap(0.6),
                  child: Column(
                    children: [
                      const Icon(Icons.accessible_forward, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        isPortuguese ? 'Largo\n0.6m' : 'Wide\n0.6m',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Statistics
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
                      isPortuguese ? 'Canteiros estimados:' : 'Estimated beds:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '$_estimatedBeds',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPortuguese ? 'Área cultivável:' : 'Cultivable area:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${_cultivableArea.toStringAsFixed(1)} m²',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPortuguese ? 'Área de caminhos:' : 'Path area:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${_pathArea.toStringAsFixed(1)} m²',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
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

class BedLayoutPainter extends CustomPainter {
  final double pathGap;
  final int bedCount;

  BedLayoutPainter({
    required this.pathGap,
    required this.bedCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bedPaint = Paint()
      ..color = Colors.green[300]!
      ..style = PaintingStyle.fill;
    
    final pathPaint = Paint()
      ..color = Colors.brown[200]!
      ..style = PaintingStyle.fill;
    
    // Draw background (paths)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pathPaint,
    );
    
    // Calculate bed layout
    const bedWidth = 40.0;
    const bedHeight = 25.0;
    final gapSize = pathGap * 20; // Scale for visualization
    
    final bedsPerRow = ((size.width - gapSize) / (bedWidth + gapSize)).floor();
    final bedsPerColumn = ((size.height - gapSize) / (bedHeight + gapSize)).floor();
    
    // Draw beds
    for (int row = 0; row < bedsPerColumn; row++) {
      for (int col = 0; col < bedsPerRow; col++) {
        final x = gapSize + col * (bedWidth + gapSize);
        final y = gapSize + row * (bedHeight + gapSize);
        
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, bedWidth, bedHeight),
            const Radius.circular(4),
          ),
          bedPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}