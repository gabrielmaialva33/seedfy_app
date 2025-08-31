import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../../../core/providers/locale_provider.dart';
import '../../../shared/data/datasources/supabase_service.dart';
import '../../../shared/domain/entities/plot.dart';
import '../screens/map_screen.dart';

class InteractiveGardenGrid extends StatefulWidget {
  final Plot plot;
  final List<BedWithPlanting> beds;
  final Function(BedWithPlanting) onBedTapped;
  final Function(Offset) onAddBed;
  final Function() onBedsUpdated;

  const InteractiveGardenGrid({
    super.key,
    required this.plot,
    required this.beds,
    required this.onBedTapped,
    required this.onAddBed,
    required this.onBedsUpdated,
  });

  @override
  State<InteractiveGardenGrid> createState() => _InteractiveGardenGridState();
}

class _InteractiveGardenGridState extends State<InteractiveGardenGrid> {
  final TransformationController _transformationController =
      TransformationController();
  static const double _gridScale = 50.0; // pixels per meter

  BedWithPlanting? _selectedBed;
  bool _isDragging = false;
  bool _isResizing = false;
  Offset? _dragStartOffset;
  Size? _resizeStartSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerView();
    });
  }

  void _centerView() {
    final centerX = (widget.plot.lengthM * _gridScale) / 2;
    final centerY = (widget.plot.widthM * _gridScale) / 2;

    _transformationController.value = Matrix4.identity()
      ..setTranslation(vector.Vector3(-centerX + 200, -centerY + 200, 0.0));
  }

  BedStatus _getBedStatus(BedWithPlanting bedWithPlanting) {
    if (bedWithPlanting.planting == null || bedWithPlanting.crop == null) {
      return BedStatus.empty;
    }

    final now = DateTime.now();
    final harvestDate = bedWithPlanting.planting!.harvestEstimate;
    final daysUntilHarvest = harvestDate.difference(now).inDays;

    if (daysUntilHarvest < 0) {
      return BedStatus.critical;
    } else if (daysUntilHarvest <= 7) {
      return BedStatus.warning;
    } else {
      return BedStatus.healthy;
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

  Future<void> _updateBedPosition(
      BedWithPlanting bedWithPlanting, double x, double y) async {
    try {
      // Convert screen coordinates to grid coordinates
      final gridX = ((x - 100) / _gridScale)
          .clamp(0.0, widget.plot.lengthM - bedWithPlanting.bed.widthM);
      final gridY = ((y - 100) / _gridScale)
          .clamp(0.0, widget.plot.widthM - bedWithPlanting.bed.heightM);

      await SupabaseService.client.from('beds').update({
        'x': gridX,
        'y': gridY,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bedWithPlanting.bed.id);

      widget.onBedsUpdated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar posição: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateBedSize(
      BedWithPlanting bedWithPlanting, double width, double height) async {
    try {
      // Convert screen size to meters
      final widthM = (width / _gridScale).clamp(0.5, 5.0);
      final heightM = (height / _gridScale).clamp(0.5, 5.0);

      await SupabaseService.client.from('beds').update({
        'width_m': widthM,
        'height_m': heightM,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bedWithPlanting.bed.id);

      widget.onBedsUpdated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar tamanho: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              painter: InteractiveGardenBackgroundPainter(
                plot: widget.plot,
                scale: _gridScale,
                selectedBed: _selectedBed,
              ),
              child: const SizedBox.expand(),
            ),

            // Tap detector for adding beds
            if (!_isDragging && !_isResizing)
              Positioned.fill(
                child: GestureDetector(
                  onTapDown: (details) {
                    final tapPosition = details.localPosition;
                    bool isOnBed = false;

                    // Check if tap is on a bed
                    for (final bedWithPlanting in widget.beds) {
                      final bedRect = Rect.fromLTWH(
                        100 + bedWithPlanting.bed.x * _gridScale,
                        100 + bedWithPlanting.bed.y * _gridScale,
                        bedWithPlanting.bed.widthM * _gridScale,
                        bedWithPlanting.bed.heightM * _gridScale,
                      );

                      if (bedRect.contains(tapPosition)) {
                        setState(() {
                          _selectedBed = bedWithPlanting;
                        });
                        isOnBed = true;
                        break;
                      }
                    }

                    if (!isOnBed) {
                      setState(() {
                        _selectedBed = null;
                      });

                      // Add new bed
                      widget.onAddBed(Offset(
                        tapPosition.dx - 100,
                        tapPosition.dy - 100,
                      ));
                    }
                  },
                ),
              ),

            // Bed widgets with drag and resize functionality
            ...widget.beds.map((bedWithPlanting) => _buildDraggableBed(
                context, bedWithPlanting, localeProvider.locale.languageCode)),

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

            // Selection info overlay
            if (_selectedBed != null)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Canteiro Selecionado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${_selectedBed!.bed.widthM.toStringAsFixed(1)}m × ${_selectedBed!.bed.heightM.toStringAsFixed(1)}m',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            color: Colors.white,
                            onPressed: () {
                              widget.onBedTapped(_selectedBed!);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _selectedBed = null;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
  }

  Widget _buildDraggableBed(
      BuildContext context, BedWithPlanting bedWithPlanting, String locale) {
    final bed = bedWithPlanting.bed;
    final status = _getBedStatus(bedWithPlanting);
    final daysUntilHarvest = _getDaysUntilHarvest(bedWithPlanting);
    final isSelected = _selectedBed?.bed.id == bed.id;

    return Positioned(
      left: 100 + bed.x * _gridScale,
      top: 100 + bed.y * _gridScale,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _selectedBed = bedWithPlanting;
            _isDragging = true;
            _dragStartOffset = details.globalPosition;
          });
        },
        onPanUpdate: (details) {
          if (_isDragging) {
            // Update position in real-time for visual feedback
            setState(() {
              // Visual update only - actual database update happens on pan end
            });
          }
        },
        onPanEnd: (details) {
          if (_isDragging && _dragStartOffset != null) {
            final deltaX = details.globalPosition.dx - _dragStartOffset!.dx;
            final deltaY = details.globalPosition.dy - _dragStartOffset!.dy;
            final newLeft = (100 + bed.x * _gridScale) + deltaX;
            final newTop = (100 + bed.y * _gridScale) + deltaY;

            _updateBedPosition(bedWithPlanting, newLeft, newTop);

            setState(() {
              _isDragging = false;
              _dragStartOffset = null;
            });
          }
        },
        onTap: () {
          if (!_isDragging && !_isResizing) {
            setState(() {
              _selectedBed = bedWithPlanting;
            });
            widget.onBedTapped(bedWithPlanting);
          }
        },
        child: Stack(
          children: [
            // Main bed container
            Container(
              width: bed.widthM * _gridScale,
              height: bed.heightM * _gridScale,
              decoration: BoxDecoration(
                color: _getBedColor(status),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.brown[700]!,
                  width: isSelected ? 3 : 2,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: isSelected ? 0.4 : 0.2),
                    blurRadius: isSelected ? 8 : 4,
                    offset: Offset(0, isSelected ? 4 : 2),
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
                                  ? (locale.startsWith('pt')
                                      ? 'Hoje!'
                                      : 'Today!')
                                  : daysUntilHarvest < 0
                                      ? (locale.startsWith('pt')
                                          ? 'Atrasado'
                                          : 'Overdue')
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

            // Resize handles for selected bed
            if (isSelected) ..._buildResizeHandles(bedWithPlanting),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles(BedWithPlanting bedWithPlanting) {
    final bed = bedWithPlanting.bed;
    const handleSize = 12.0;

    return [
      // Bottom-right resize handle
      Positioned(
        right: -handleSize / 2,
        bottom: -handleSize / 2,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isResizing = true;
              _resizeStartSize = Size(
                bed.widthM * _gridScale,
                bed.heightM * _gridScale,
              );
            });
          },
          onPanUpdate: (details) {
            if (_isResizing) {
              // Visual feedback only
              setState(() {});
            }
          },
          onPanEnd: (details) {
            if (_isResizing) {
              final newWidth = (_resizeStartSize!.width +
                      details.velocity.pixelsPerSecond.dx / 10)
                  .clamp(25.0, 250.0);
              final newHeight = (_resizeStartSize!.height +
                      details.velocity.pixelsPerSecond.dy / 10)
                  .clamp(25.0, 250.0);

              _updateBedSize(bedWithPlanting, newWidth, newHeight);

              setState(() {
                _isResizing = false;
                _resizeStartSize = null;
              });
            }
          },
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(handleSize / 2),
            ),
            child: const Icon(
              Icons.drag_indicator,
              size: 8,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }
}

class InteractiveGardenBackgroundPainter extends CustomPainter {
  final Plot plot;
  final double scale;
  final BedWithPlanting? selectedBed;

  InteractiveGardenBackgroundPainter({
    required this.plot,
    required this.scale,
    this.selectedBed,
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

    final snapGridPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw paths background
    canvas.drawRect(
      Rect.fromLTWH(100, 100, plot.lengthM * scale, plot.widthM * scale),
      pathPaint,
    );

    // Draw fine grid lines every 0.5 meters
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

    // Draw snap grid lines every 1 meter (thicker)
    if (selectedBed != null) {
      for (double x = 0; x <= plot.lengthM; x += 1.0) {
        canvas.drawLine(
          Offset(100 + x * scale, 100),
          Offset(100 + x * scale, 100 + plot.widthM * scale),
          snapGridPaint,
        );
      }

      for (double y = 0; y <= plot.widthM; y += 1.0) {
        canvas.drawLine(
          Offset(100, 100 + y * scale),
          Offset(100 + plot.lengthM * scale, 100 + y * scale),
          snapGridPaint,
        );
      }
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
