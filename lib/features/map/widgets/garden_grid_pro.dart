import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../models/plot.dart';
import '../screens/map_screen.dart';

class GardenGridPro extends StatefulWidget {
  final Plot plot;
  final List<BedWithPlanting> beds;
  final Function(BedWithPlanting) onBedTapped;
  final Function(Offset) onAddBed;

  const GardenGridPro({
    super.key,
    required this.plot,
    required this.beds,
    required this.onBedTapped,
    required this.onAddBed,
  });

  @override
  State<GardenGridPro> createState() => _GardenGridProState();
}

class _GardenGridProState extends State<GardenGridPro>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  
  static const double _gridScale = 60.0; // pixels per meter
  static const double _minScale = 0.5;
  static const double _maxScale = 3.0;
  
  bool _isAddingMode = false;
  Offset? _newBedPosition;

  @override
  void initState() {
    super.initState();
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOut,
    ));
    
    // Center the view on the garden
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerView();
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _centerView() {
    final screenSize = MediaQuery.of(context).size;
    final plotWidth = widget.plot.lengthM * _gridScale;
    final plotHeight = widget.plot.widthM * _gridScale;
    
    final centerX = (screenSize.width - plotWidth) / 2;
    final centerY = (screenSize.height - plotHeight) / 2;
    
    _transformationController.value = Matrix4.identity()
      ..translate(centerX, centerY)
      ..scale(1.0);
  }

  BedStatus _getBedStatus(BedWithPlanting bedWithPlanting) {
    if (bedWithPlanting.planting == null || bedWithPlanting.crop == null) {
      return BedStatus.empty;
    }
    
    final now = DateTime.now();
    final harvestDate = bedWithPlanting.planting!.harvestEstimate;
    final totalDays = harvestDate.difference(bedWithPlanting.planting!.sowingDate).inDays;
    final daysElapsed = now.difference(bedWithPlanting.planting!.sowingDate).inDays;
    
    if (totalDays <= 0) return BedStatus.empty;
    
    final progressPercent = daysElapsed / totalDays;
    
    if (progressPercent < 0.5) {
      return BedStatus.healthy; // Verde - >50% do tempo restante
    } else if (progressPercent < 0.8) {
      return BedStatus.warning; // Amarelo - 20-50% do tempo restante
    } else {
      return BedStatus.critical; // Vermelho - <20% do tempo restante ou vencido
    }
  }

  Color _getStatusColor(BedStatus status) {
    switch (status) {
      case BedStatus.healthy:
        return Colors.green;
      case BedStatus.warning:
        return Colors.orange;
      case BedStatus.critical:
        return Colors.red;
      case BedStatus.empty:
        return Colors.grey.shade300;
    }
  }

  IconData _getStatusIcon(BedStatus status) {
    switch (status) {
      case BedStatus.healthy:
        return Icons.eco;
      case BedStatus.warning:
        return Icons.schedule;
      case BedStatus.critical:
        return Icons.warning;
      case BedStatus.empty:
        return Icons.add;
    }
  }

  void _toggleAddingMode() {
    setState(() {
      _isAddingMode = !_isAddingMode;
      _newBedPosition = null;
    });
  }

  void _handleTapOnGrid(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    // Convert to grid coordinates considering transformation
    final transform = _transformationController.value;
    final invertedTransform = Matrix4.inverted(transform);
    final transformedPosition = MatrixUtils.transformPoint(invertedTransform, localPosition);
    
    final gridX = (transformedPosition.dx / _gridScale).round();
    final gridY = (transformedPosition.dy / _gridScale).round();
    
    // Check bounds
    if (gridX < 0 || gridY < 0 || 
        gridX >= widget.plot.lengthM || gridY >= widget.plot.widthM) {
      return;
    }
    
    // Check if there's already a bed at this position
    final existingBed = widget.beds.firstWhere(
      (bed) => bed.bed.x == gridX && bed.bed.y == gridY,
      orElse: () => BedWithPlanting(
        bed: widget.beds.first.bed, // dummy
        planting: null,
        crop: null,
      ),
    );
    
    if (widget.beds.any((bed) => bed.bed.x == gridX && bed.bed.y == gridY)) {
      // Tap on existing bed
      widget.onBedTapped(existingBed);
    } else if (_isAddingMode) {
      // Add new bed
      widget.onAddBed(Offset(gridX.toDouble(), gridY.toDouble()));
      setState(() {
        _isAddingMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';
    
    return Scaffold(
      body: Stack(
        children: [
          // Grid background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade50,
                  Colors.blue.shade50,
                ],
              ),
            ),
          ),
          
          // Interactive grid
          GestureDetector(
            onTapUp: _handleTapOnGrid,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: _minScale,
              maxScale: _maxScale,
              boundaryMargin: const EdgeInsets.all(100),
              child: CustomPaint(
                size: Size(
                  widget.plot.lengthM * _gridScale,
                  widget.plot.widthM * _gridScale,
                ),
                painter: GardenGridPainter(
                  plot: widget.plot,
                  beds: widget.beds,
                  gridScale: _gridScale,
                  getBedStatus: _getBedStatus,
                  getStatusColor: _getStatusColor,
                  isPortuguese: isPortuguese,
                  isAddingMode: _isAddingMode,
                ),
              ),
            ),
          ),
          
          // Mode indicator
          if (_isAddingMode)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isPortuguese 
                          ? 'Toque para adicionar um canteiro'
                          : 'Tap to add a new bed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _toggleAddingMode,
                      child: Text(
                        isPortuguese ? 'Cancelar' : 'Cancel',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      
      // Floating action buttons
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add bed button
                FloatingActionButton(
                  heroTag: "add_bed",
                  onPressed: _toggleAddingMode,
                  backgroundColor: _isAddingMode ? Colors.red : Colors.green,
                  child: Icon(
                    _isAddingMode ? Icons.close : Icons.add,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Center view button
                FloatingActionButton.small(
                  heroTag: "center_view",
                  onPressed: _centerView,
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.center_focus_strong,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GardenGridPainter extends CustomPainter {
  final Plot plot;
  final List<BedWithPlanting> beds;
  final double gridScale;
  final BedStatus Function(BedWithPlanting) getBedStatus;
  final Color Function(BedStatus) getStatusColor;
  final bool isPortuguese;
  final bool isAddingMode;

  GardenGridPainter({
    required this.plot,
    required this.beds,
    required this.gridScale,
    required this.getBedStatus,
    required this.getStatusColor,
    required this.isPortuguese,
    required this.isAddingMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;
    
    final pathPaint = Paint()
      ..color = Colors.brown.shade200
      ..strokeWidth = plot.pathGapM * gridScale;

    // Draw ground
    final groundPaint = Paint()
      ..color = Colors.brown.shade100;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), groundPaint);

    // Draw grid lines
    for (double i = 0; i <= plot.lengthM; i++) {
      canvas.drawLine(
        Offset(i * gridScale, 0),
        Offset(i * gridScale, size.height),
        gridPaint,
      );
    }
    
    for (double i = 0; i <= plot.widthM; i++) {
      canvas.drawLine(
        Offset(0, i * gridScale),
        Offset(size.width, i * gridScale),
        gridPaint,
      );
    }

    // Draw paths between beds
    if (plot.pathGapM > 0) {
      for (double i = 0.5; i < plot.lengthM; i++) {
        canvas.drawLine(
          Offset((i + 0.5) * gridScale, 0),
          Offset((i + 0.5) * gridScale, size.height),
          pathPaint,
        );
      }
      
      for (double i = 0.5; i < plot.widthM; i++) {
        canvas.drawLine(
          Offset(0, (i + 0.5) * gridScale),
          Offset(size.width, (i + 0.5) * gridScale),
          pathPaint,
        );
      }
    }

    // Draw beds
    for (final bedWithPlanting in beds) {
      final bed = bedWithPlanting.bed;
      final status = getBedStatus(bedWithPlanting);
      
      final bedRect = Rect.fromLTWH(
        bed.x * gridScale + 5,
        bed.y * gridScale + 5,
        bed.widthM * gridScale - 10,
        bed.heightM * gridScale - 10,
      );
      
      // Bed shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          bedRect.translate(2, 2),
          const Radius.circular(8),
        ),
        shadowPaint,
      );
      
      // Bed background
      final bedPaint = Paint()
        ..color = getStatusColor(status).withOpacity(0.8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(bedRect, const Radius.circular(8)),
        bedPaint,
      );
      
      // Bed border
      final borderPaint = Paint()
        ..color = getStatusColor(status)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(bedRect, const Radius.circular(8)),
        borderPaint,
      );
      
      // Draw crop icon if planted
      if (bedWithPlanting.crop != null) {
        _drawCropIcon(canvas, bedRect.center, bedWithPlanting.crop!);
      }
      
      // Draw status indicator
      _drawStatusIndicator(canvas, bedRect, status);
    }
  }

  void _drawCropIcon(Canvas canvas, Offset center, dynamic crop) {
    final iconPaint = Paint()
      ..color = Colors.green.shade700;
    
    // Simple plant representation
    canvas.drawCircle(center, 8, iconPaint);
    
    // Add leaves
    final leafPaint = Paint()
      ..color = Colors.green.shade600;
    canvas.drawCircle(center.translate(-5, -3), 4, leafPaint);
    canvas.drawCircle(center.translate(5, -3), 4, leafPaint);
  }

  void _drawStatusIndicator(Canvas canvas, Rect bedRect, BedStatus status) {
    if (status == BedStatus.empty) return;
    
    final indicatorRect = Rect.fromLTWH(
      bedRect.right - 16,
      bedRect.top + 4,
      12,
      12,
    );
    
    final indicatorPaint = Paint()
      ..color = getStatusColor(status);
    
    canvas.drawCircle(indicatorRect.center, 6, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant GardenGridPainter oldDelegate) {
    return oldDelegate.beds != beds ||
           oldDelegate.isAddingMode != isAddingMode;
  }
}