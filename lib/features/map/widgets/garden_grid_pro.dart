import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
  late AnimationController _pulseBedController;
  late AnimationController _hoverController;
  late AnimationController _bedEntryController;

  late Animation<double> _fabAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _bedEntryAnimation;

  static const double _gridScale = 60.0; // pixels per meter
  static const double _minScale = 0.5;
  static const double _maxScale = 3.0;

  bool _isAddingMode = false;
  int? _hoveredBedIndex;
  final Set<int> _newBedIndices = <int>{};

  @override
  void initState() {
    super.initState();

    // FAB Animation
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    // Pulsing bed animation for critical status
    _pulseBedController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseBedController,
      curve: Curves.easeInOut,
    ));

    // Hover effect animation
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    // Bed entry animation (cascading effect)
    _bedEntryController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bedEntryAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bedEntryController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerView();
      _fabAnimationController.forward();
      _bedEntryController.forward();
      _pulseBedController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _pulseBedController.dispose();
    _hoverController.dispose();
    _bedEntryController.dispose();
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
      ..setTranslation(vector.Vector3(centerX, centerY, 0.0))
      ..scale(1.0, 1.0, 1.0);
  }

  BedStatus _getBedStatus(BedWithPlanting bedWithPlanting) {
    if (bedWithPlanting.planting == null || bedWithPlanting.crop == null) {
      return BedStatus.empty;
    }

    final now = DateTime.now();
    final harvestDate = bedWithPlanting.planting!.harvestEstimate;
    final totalDays =
        harvestDate.difference(bedWithPlanting.planting!.sowingDate).inDays;
    final daysElapsed =
        now.difference(bedWithPlanting.planting!.sowingDate).inDays;

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

  void _toggleAddingMode() {
    setState(() {
      _isAddingMode = !_isAddingMode;
    });
  }

  void _handleTapOnGrid(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Convert to grid coordinates considering transformation
    final transform = _transformationController.value;
    final invertedTransform = Matrix4.inverted(transform);
    final transformedPosition =
        MatrixUtils.transformPoint(invertedTransform, localPosition);

    final gridX = (transformedPosition.dx / _gridScale).round();
    final gridY = (transformedPosition.dy / _gridScale).round();

    // Check bounds
    if (gridX < 0 ||
        gridY < 0 ||
        gridX >= widget.plot.lengthM ||
        gridY >= widget.plot.widthM) {
      return;
    }

    // Check if there's already a bed at this position
    final existingBedIndex = widget.beds.indexWhere(
      (bed) => bed.bed.x == gridX && bed.bed.y == gridY,
    );

    if (existingBedIndex != -1) {
      // Tap on existing bed - add bounce animation
      _triggerBedBounce(existingBedIndex);
      widget.onBedTapped(widget.beds[existingBedIndex]);
    } else if (_isAddingMode) {
      // Add new bed with entry animation
      final newBedIndex = widget.beds.length;
      _newBedIndices.add(newBedIndex);
      widget.onAddBed(Offset(gridX.toDouble(), gridY.toDouble()));
      setState(() {
        _isAddingMode = false;
      });

      // Trigger add bed animation
      Future.delayed(const Duration(milliseconds: 100), () {
        _triggerNewBedAnimation();
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
          // Enhanced gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.4, 0.8, 1.0],
                colors: [
                  Colors.green.shade50,
                  Colors.blue.shade50,
                  Colors.purple.shade50,
                  Colors.orange.shade50,
                ],
              ),
            ),
          ),

          // Interactive grid with hover detection
          GestureDetector(
            onTapUp: _handleTapOnGrid,
            child: MouseRegion(
              onHover: (event) => _detectHoveredBed(event.localPosition),
              onExit: (_) => _handleHover(null),
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: _minScale,
                maxScale: _maxScale,
                boundaryMargin: const EdgeInsets.all(100),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseAnimation,
                    _hoverAnimation,
                    _bedEntryAnimation,
                  ]),
                  builder: (context, child) {
                    return CustomPaint(
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
                        pulseValue: _pulseAnimation.value,
                        hoverValue: _hoverAnimation.value,
                        entryValue: _bedEntryAnimation.value,
                        hoveredBedIndex: _hoveredBedIndex,
                        newBedIndices: _newBedIndices,
                      ),
                    );
                  },
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
                      color: Colors.black.withValues(alpha: 0.1),
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
                // Demo mode button (new)
                FloatingActionButton.small(
                  heroTag: "demo_mode",
                  onPressed: _startDemoMode,
                  backgroundColor: Colors.purple,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Add bed button with rotation animation
                AnimatedRotation(
                  turns: _isAddingMode ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: FloatingActionButton(
                    heroTag: "add_bed",
                    onPressed: _toggleAddingMode,
                    backgroundColor: _isAddingMode ? Colors.red : Colors.green,
                    elevation: _isAddingMode ? 8 : 4,
                    child: Icon(
                      _isAddingMode ? Icons.close : Icons.add,
                      color: Colors.white,
                    ),
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

  void _triggerBedBounce(int bedIndex) {
    // Create a quick bounce effect for tapped beds
    _hoverController.forward().then((_) {
      _hoverController.reverse();
    });
  }

  void _triggerNewBedAnimation() {
    // Reset and replay entry animation for new beds
    _bedEntryController.reset();
    _bedEntryController.forward();
  }

  void _handleHover(int? bedIndex) {
    if (_hoveredBedIndex != bedIndex) {
      setState(() {
        _hoveredBedIndex = bedIndex;
      });

      if (bedIndex != null) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }

  void _detectHoveredBed(Offset localPosition) {
    final transform = _transformationController.value;
    final invertedTransform = Matrix4.inverted(transform);
    final transformedPosition =
        MatrixUtils.transformPoint(invertedTransform, localPosition);

    int? hoveredIndex;
    for (int i = 0; i < widget.beds.length; i++) {
      final bed = widget.beds[i].bed;
      final bedRect = Rect.fromLTWH(
        bed.x * _gridScale,
        bed.y * _gridScale,
        bed.widthM * _gridScale,
        bed.heightM * _gridScale,
      );

      if (bedRect.contains(transformedPosition)) {
        hoveredIndex = i;
        break;
      }
    }

    _handleHover(hoveredIndex);
  }

  void _startDemoMode() {
    // Showcase demo with automatic animations
    _showDemoDialog();
  }

  void _showDemoDialog() {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(isPortuguese ? '🚀 Demo Interativo' : '🚀 Interactive Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPortuguese
                  ? '✨ Recursos demonstrados:'
                  : '✨ Demonstrated features:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(isPortuguese
                ? '🎯 Animações 3D suaves'
                : '🎯 Smooth 3D animations'),
            Text(isPortuguese
                ? '💡 Efeitos de hover interativos'
                : '💡 Interactive hover effects'),
            Text(isPortuguese ? '⚡ Transições fluidas' : '⚡ Fluid transitions'),
            Text(isPortuguese
                ? '🌱 Status pulsante para plantas críticas'
                : '🌱 Pulsing status for critical plants'),
            Text(isPortuguese
                ? '🎨 Gradientes modernos'
                : '🎨 Modern gradients'),
            const SizedBox(height: 12),
            Text(
              isPortuguese
                  ? 'Mova o mouse sobre os canteiros para ver os efeitos!'
                  : 'Hover over garden beds to see the effects!',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isPortuguese ? 'Começar Demo' : 'Start Demo'),
          ),
        ],
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
  final double pulseValue;
  final double hoverValue;
  final double entryValue;
  final int? hoveredBedIndex;
  final Set<int> newBedIndices;

  GardenGridPainter({
    required this.plot,
    required this.beds,
    required this.gridScale,
    required this.getBedStatus,
    required this.getStatusColor,
    required this.isPortuguese,
    required this.isAddingMode,
    required this.pulseValue,
    required this.hoverValue,
    required this.entryValue,
    required this.hoveredBedIndex,
    required this.newBedIndices,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final pathPaint = Paint()
      ..color = Colors.brown.shade200
      ..strokeWidth = plot.pathGapM * gridScale;

    // Draw ground
    final groundPaint = Paint()..color = Colors.brown.shade100;
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

    // Draw beds with animations
    for (int i = 0; i < beds.length; i++) {
      final bedWithPlanting = beds[i];
      final bed = bedWithPlanting.bed;
      final status = getBedStatus(bedWithPlanting);

      // Calculate animation values for this bed
      double scaleValue = 1.0;
      double opacityValue = 1.0;

      // Entry animation (cascading effect)
      final entryDelay = i * 0.1;
      final adjustedEntryValue = (entryValue - entryDelay).clamp(0.0, 1.0);
      scaleValue *= (0.5 + 0.5 * adjustedEntryValue);
      opacityValue *= adjustedEntryValue;

      // Hover effect
      if (hoveredBedIndex == i) {
        scaleValue *= hoverValue;
      }

      // Pulsing effect for critical beds
      if (status == BedStatus.critical) {
        scaleValue *= pulseValue;
      }

      // New bed animation
      if (newBedIndices.contains(i)) {
        scaleValue *= (0.8 + 0.4 * entryValue);
      }

      final bedRect = Rect.fromLTWH(
        bed.x * gridScale + 5,
        bed.y * gridScale + 5,
        bed.widthM * gridScale - 10,
        bed.heightM * gridScale - 10,
      );

      // Apply scaling from center
      final center = bedRect.center;
      final scaledRect = Rect.fromCenter(
        center: center,
        width: bedRect.width * scaleValue,
        height: bedRect.height * scaleValue,
      );

      // Enhanced shadow with scaling
      final shadowOpacity = (0.1 * opacityValue * scaleValue).clamp(0.0, 0.3);
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: shadowOpacity);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          scaledRect.translate(3 * scaleValue, 3 * scaleValue),
          Radius.circular(8 * scaleValue),
        ),
        shadowPaint,
      );

      // Bed background with glow effect
      final bedColor = getStatusColor(status);
      final bedPaint = Paint()
        ..color = bedColor.withValues(alpha: 0.8 * opacityValue);

      // Add glow for hovered or critical beds
      if (hoveredBedIndex == i || status == BedStatus.critical) {
        final glowPaint = Paint()
          ..color = bedColor.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawRRect(
          RRect.fromRectAndRadius(scaledRect, Radius.circular(8 * scaleValue)),
          glowPaint,
        );
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(scaledRect, Radius.circular(8 * scaleValue)),
        bedPaint,
      );

      // Enhanced border with animation
      final borderPaint = Paint()
        ..color = bedColor.withValues(alpha: opacityValue)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scaleValue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(scaledRect, Radius.circular(8 * scaleValue)),
        borderPaint,
      );

      // Draw crop icon if planted (scaled)
      if (bedWithPlanting.crop != null && opacityValue > 0.5) {
        _drawCropIcon(canvas, scaledRect.center, bedWithPlanting.crop!,
            scaleValue * opacityValue);
      }

      // Draw status indicator (scaled)
      _drawStatusIndicator(
          canvas, scaledRect, status, scaleValue * opacityValue);
    }
  }

  void _drawCropIcon(Canvas canvas, Offset center, dynamic crop, double scale) {
    final iconPaint = Paint()
      ..color = Colors.green.shade700.withValues(alpha: scale);

    // Simple plant representation with scaling
    canvas.drawCircle(center, 8 * scale, iconPaint);

    // Add leaves with scaling
    final leafPaint = Paint()
      ..color = Colors.green.shade600.withValues(alpha: scale);
    canvas.drawCircle(
        center.translate(-5 * scale, -3 * scale), 4 * scale, leafPaint);
    canvas.drawCircle(
        center.translate(5 * scale, -3 * scale), 4 * scale, leafPaint);
  }

  void _drawStatusIndicator(
      Canvas canvas, Rect bedRect, BedStatus status, double scale) {
    if (status == BedStatus.empty || scale < 0.3) return;

    final indicatorRect = Rect.fromLTWH(
      bedRect.right - 16 * scale,
      bedRect.top + 4 * scale,
      12 * scale,
      12 * scale,
    );

    final indicatorPaint = Paint()
      ..color = getStatusColor(status).withValues(alpha: scale);

    // Add pulsing effect for critical status
    final indicatorScale =
        status == BedStatus.critical ? scale * pulseValue : scale;
    canvas.drawCircle(indicatorRect.center, 6 * indicatorScale, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant GardenGridPainter oldDelegate) {
    return oldDelegate.beds != beds ||
        oldDelegate.isAddingMode != isAddingMode ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.hoverValue != hoverValue ||
        oldDelegate.entryValue != entryValue ||
        oldDelegate.hoveredBedIndex != hoveredBedIndex;
  }
}
