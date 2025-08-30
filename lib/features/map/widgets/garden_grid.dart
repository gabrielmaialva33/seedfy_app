import 'package:flutter/material.dart';

class GardenGrid extends StatefulWidget {
  final double plotLength;
  final double plotWidth;
  final double pathGap;
  final List<BedData> beds;
  final Function(BedData) onBedTapped;
  final Function(Offset) onAddBed;

  const GardenGrid({
    super.key,
    required this.plotLength,
    required this.plotWidth,
    required this.pathGap,
    required this.beds,
    required this.onBedTapped,
    required this.onAddBed,
  });

  @override
  State<GardenGrid> createState() => _GardenGridState();
}

class _GardenGridState extends State<GardenGrid> {
  final TransformationController _transformationController = TransformationController();
  static const double _bedMinSize = 50.0;
  static const double _gridScale = 50.0; // pixels per meter

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      constrained: false,
      child: Container(
        width: widget.plotLength * _gridScale + 100,
        height: widget.plotWidth * _gridScale + 100,
        color: Colors.brown[100],
        child: CustomPaint(
          painter: GardenGridPainter(
            plotLength: widget.plotLength,
            plotWidth: widget.plotWidth,
            pathGap: widget.pathGap,
            beds: widget.beds,
            scale: _gridScale,
          ),
          child: GestureDetector(
            onTapDown: (details) {
              final offset = details.localPosition;
              widget.onAddBed(offset);
            },
            child: Stack(
              children: widget.beds.map((bed) => _buildBedWidget(bed)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBedWidget(BedData bed) {
    return Positioned(
      left: bed.x * _gridScale,
      top: bed.y * _gridScale,
      child: GestureDetector(
        onTap: () => widget.onBedTapped(bed),
        child: Container(
          width: bed.widthM * _gridScale,
          height: bed.heightM * _gridScale,
          decoration: BoxDecoration(
            color: _getBedColor(bed.status),
            border: Border.all(color: Colors.brown[400]!, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (bed.cropName.isNotEmpty)
                  Text(
                    bed.cropName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (bed.daysUntilHarvest >= 0)
                  Text(
                    '${bed.daysUntilHarvest}d',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBedColor(BedStatus status) {
    switch (status) {
      case BedStatus.healthy:
        return Colors.green;
      case BedStatus.warning:
        return Colors.orange;
      case BedStatus.critical:
        return Colors.red;
      case BedStatus.empty:
        return Colors.grey[300]!;
    }
  }
}

class GardenGridPainter extends CustomPainter {
  final double plotLength;
  final double plotWidth;
  final double pathGap;
  final List<BedData> beds;
  final double scale;

  GardenGridPainter({
    required this.plotLength,
    required this.plotWidth,
    required this.pathGap,
    required this.beds,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown[300]!
      ..strokeWidth = 1;

    // Desenhar grid de referência
    for (double x = 0; x <= plotLength; x += 0.5) {
      canvas.drawLine(
        Offset(x * scale, 0),
        Offset(x * scale, plotWidth * scale),
        paint,
      );
    }

    for (double y = 0; y <= plotWidth; y += 0.5) {
      canvas.drawLine(
        Offset(0, y * scale),
        Offset(plotLength * scale, y * scale),
        paint,
      );
    }

    // Desenhar bordas da área
    final borderPaint = Paint()
      ..color = Colors.brown[700]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, plotLength * scale, plotWidth * scale),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum BedStatus {
  healthy,
  warning,
  critical,
  empty,
}

class BedData {
  final String id;
  final double x;
  final double y;
  final double widthM;
  final double heightM;
  final String cropName;
  final BedStatus status;
  final int daysUntilHarvest;

  const BedData({
    required this.id,
    required this.x,
    required this.y,
    required this.widthM,
    required this.heightM,
    this.cropName = '',
    this.status = BedStatus.empty,
    this.daysUntilHarvest = -1,
  });
}