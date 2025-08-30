import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../models/plot.dart';
import '../screens/map_screen.dart';

class GardenGridEnhanced extends StatefulWidget {
  final Plot plot;
  final List<BedWithPlanting> beds;
  final Function(BedWithPlanting) onBedTapped;
  final Function(Offset) onAddBed;

  const GardenGridEnhanced({
    Key? key,
    required this.plot,
    required this.beds,
    required this.onBedTapped,
    required this.onAddBed,
  }) : super(key: key);

  @override
  State<GardenGridEnhanced> createState() => _GardenGridEnhancedState();
}

class _GardenGridEnhancedState extends State<GardenGridEnhanced> {
  final TransformationController _transformationController = TransformationController();
  static const double _gridScale = 50.0; // pixels per meter
  
  @override
  void initState() {
    super.initState();
    // Center the view on the garden
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerView();
    });
  }

  void _centerView() {
    final centerX = (widget.plot.lengthM * _gridScale) / 2;
    final centerY = (widget.plot.widthM * _gridScale) / 2;
    
    _transformationController.value = Matrix4.identity()
      ..translate(-centerX + 200, -centerY + 200)
      ..scale(1.0);
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

  Color _getBedColor(BedStatus status) {
    switch (status) {
      case BedStatus.healthy:
        return Colors.green[400]!;
      case BedStatus.warning:
        return Colors.orange[400]!;
      case BedStatus.critical:
        return Colors.red[400]!;
      case BedStatus.empty:
        return Colors.grey[300]!;
    }
  }

  int _getDaysUntilHarvest(BedWithPlanting bedWithPlanting) {
    if (bedWithPlanting.planting == null) return -1;
    
    final now = DateTime.now();
    final harvestDate = bedWithPlanting.planting!.harvestEstimate;
    return harvestDate.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.3,
      maxScale: 5.0,
      constrained: false,
      child: Container(
        width: widget.plot.lengthM * _gridScale + 200,
        height: widget.plot.widthM * _gridScale + 200,
        decoration: BoxDecoration(
          color: Colors.brown[100],
          border: Border.all(color: Colors.brown[300]!, width: 2),
        ),
        child: Stack(
          children: [
            // Background grid
            CustomPaint(
              painter: GardenBackgroundPainter(
                plot: widget.plot,
                scale: _gridScale,
              ),
              child: const SizedBox.expand(),
            ),
            
            // Tap detector for adding beds
            Positioned.fill(
              child: GestureDetector(
                onTapDown: (details) {
                  // Check if tap is on empty space
                  final tapPosition = details.localPosition;
                  bool isOnBed = false;
                  
                  for (final bedWithPlanting in widget.beds) {
                    final bedRect = Rect.fromLTWH(
                      100 + bedWithPlanting.bed.x * _gridScale,
                      100 + bedWithPlanting.bed.y * _gridScale,
                      bedWithPlanting.bed.widthM * _gridScale,
                      bedWithPlanting.bed.heightM * _gridScale,
                    );
                    
                    if (bedRect.contains(tapPosition)) {
                      isOnBed = true;
                      break;
                    }
                  }
                  
                  if (!isOnBed) {
                    widget.onAddBed(Offset(
                      tapPosition.dx - 100,
                      tapPosition.dy - 100,
                    ));
                  }
                },
              ),
            ),
            
            // Bed widgets
            ...widget.beds.map((bedWithPlanting) => _buildBedWidget(
              context, 
              bedWithPlanting, 
              localeProvider.locale.languageCode
            )),
            
            // Plot info overlay
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plot.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.plot.lengthM}m × ${widget.plot.widthM}m',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${widget.plot.areaM2.toStringAsFixed(1)} m²',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedWidget(BuildContext context, BedWithPlanting bedWithPlanting, String locale) {
    final bed = bedWithPlanting.bed;
    final status = _getBedStatus(bedWithPlanting);
    final daysUntilHarvest = _getDaysUntilHarvest(bedWithPlanting);
    
    return Positioned(
      left: 100 + bed.x * _gridScale,
      top: 100 + bed.y * _gridScale,
      child: GestureDetector(
        onTap: () => widget.onBedTapped(bedWithPlanting),
        child: Container(
          width: bed.widthM * _gridScale,
          height: bed.heightM * _gridScale,
          decoration: BoxDecoration(
            color: _getBedColor(status),
            border: Border.all(
              color: Colors.brown[700]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Bed content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (bedWithPlanting.crop != null)
                      Flexible(
                        child: Text(
                          bedWithPlanting.crop!.getName(locale),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    
                    if (daysUntilHarvest >= 0) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          daysUntilHarvest == 0
                            ? (locale.startsWith('pt') ? 'Hoje!' : 'Today!')
                            : daysUntilHarvest < 0
                              ? (locale.startsWith('pt') ? 'Atrasado' : 'Overdue')
                              : '${daysUntilHarvest}d',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Status indicator
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getBedColor(status),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
              
              // Quantity indicator
              if (bedWithPlanting.planting != null)
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${bedWithPlanting.planting!.quantity}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GardenBackgroundPainter extends CustomPainter {
  final Plot plot;
  final double scale;

  GardenBackgroundPainter({
    required this.plot,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.brown[300]!
      ..strokeWidth = 0.5;

    final pathPaint = Paint()
      ..color = Colors.brown[200]!
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.brown[700]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw paths background
    canvas.drawRect(
      Rect.fromLTWH(100, 100, plot.lengthM * scale, plot.widthM * scale),
      pathPaint,
    );

    // Draw grid lines every 0.5 meters
    for (double x = 0; x <= plot.lengthM; x += 0.5) {
      canvas.drawLine(
        Offset(100 + x * scale, 100),
        Offset(100 + x * scale, 100 + plot.widthM * scale),
        gridPaint,
      );
    }

    for (double y = 0; y <= plot.widthM; y += 0.5) {
      canvas.drawLine(
        Offset(100, 100 + y * scale),
        Offset(100 + plot.lengthM * scale, 100 + y * scale),
        gridPaint,
      );
    }

    // Draw plot border
    canvas.drawRect(
      Rect.fromLTWH(100, 100, plot.lengthM * scale, plot.widthM * scale),
      borderPaint,
    );

    // Draw measurements
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Length measurement
    textPainter.text = TextSpan(
      text: '${plot.lengthM.toStringAsFixed(1)}m',
      style: const TextStyle(
        color: Colors.brown,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(100 + (plot.lengthM * scale / 2) - (textPainter.width / 2), 75),
    );

    // Width measurement
    canvas.save();
    canvas.translate(75, 100 + (plot.widthM * scale / 2));
    canvas.rotate(-1.5708); // -90 degrees
    textPainter.text = TextSpan(
      text: '${plot.widthM.toStringAsFixed(1)}m',
      style: const TextStyle(
        color: Colors.brown,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}