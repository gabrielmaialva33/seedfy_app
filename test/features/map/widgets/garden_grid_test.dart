import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seedfy_app/core/providers/locale_provider.dart';
import 'package:seedfy_app/features/map/screens/map_screen.dart';
import 'package:seedfy_app/features/map/widgets/garden_grid.dart';
import 'package:seedfy_app/shared/domain/entities/bed.dart';
import 'package:seedfy_app/shared/domain/entities/crop.dart';
import 'package:seedfy_app/shared/domain/entities/planting.dart';
import 'package:seedfy_app/shared/domain/entities/plot.dart';

void main() {
  group('GardenGrid Widget', () {
    late Plot testPlot;
    late List<BedWithPlanting> testBeds;
    late Function(BedWithPlanting) onBedTapped;
    late Function(Offset) onAddBed;

    setUp(() {
      testPlot = Plot(
        id: 'test-plot-1',
        farmId: 'test-farm-1',
        label: 'Test Garden Plot',
        lengthM: 10.0,
        widthM: 8.0,
        pathGapM: 0.5,
        createdAt: DateTime.now(),
      );

      final testCrop = Crop(
        id: 'test-crop-1',
        namePt: 'Tomate',
        nameEn: 'Tomato',
        imageUrl: 'https://example.com/tomato.jpg',
        cycleDays: 90,
        plantSpacingM: 0.5,
        rowSpacingM: 0.8,
        yieldPerM2: 5.0,
      );

      final testBed = Bed(
        id: 'test-bed-1',
        plotId: 'test-plot-1',
        x: 2,
        y: 1,
        widthM: 1.2,
        heightM: 2.0,
        createdAt: DateTime.now(),
      );

      final testPlanting = Planting(
        id: 'test-planting-1',
        bedId: 'test-bed-1',
        cropId: 'test-crop-1',
        sowingDate: DateTime.now().subtract(const Duration(days: 30)),
        harvestEstimate: DateTime.now().add(const Duration(days: 60)),
        quantity: 4,
        customCycleDays: null,
      );

      testBeds = [
        BedWithPlanting(
          bed: testBed,
          planting: testPlanting,
          crop: testCrop,
        ),
      ];

      onBedTapped = (bed) {};
      onAddBed = (offset) {};
    });

    Widget createWidgetUnderTest({
      Plot? plot,
      List<BedWithPlanting>? beds,
      Function(BedWithPlanting)? onTapped,
      Function(Offset)? onAdd,
    }) {
      final localeProvider = LocaleProvider();
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider.value(
            value: localeProvider,
            child: GardenGrid(
              plot: plot ?? testPlot,
              beds: beds ?? testBeds,
              onBedTapped: onTapped ?? onBedTapped,
              onAddBed: onAdd ?? onAddBed,
            ),
          ),
        ),
      );
    }

    testWidgets('should render GardenGrid with plot information',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify plot information is displayed
      expect(find.text('Test Garden Plot'), findsOneWidget);
      expect(find.text('10.0m × 8.0m'), findsOneWidget);
      expect(find.text('80.0 m²'), findsOneWidget);
    });

    testWidgets('should render InteractiveViewer for pan and zoom',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('should render CustomPaint for background grid',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should render beds with plantings', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Should find bed widget
      expect(find.text('Tomate'), findsOneWidget);
      expect(find.text('4'), findsOneWidget); // quantity
    });

    testWidgets('should handle bed tap', (tester) async {
      bool bedTapped = false;
      BedWithPlanting? tappedBed;

      await tester.pumpWidget(createWidgetUnderTest(
        onTapped: (bed) {
          bedTapped = true;
          tappedBed = bed;
        },
      ));

      // Find and tap the bed
      final bedWidget = find.text('Tomate');
      expect(bedWidget, findsOneWidget);

      await tester.tap(bedWidget);
      await tester.pump();

      expect(bedTapped, isTrue);
      expect(tappedBed, isNotNull);
      expect(tappedBed!.bed.id, 'test-bed-1');
    });

    testWidgets('should handle add bed tap on empty space', (tester) async {
      bool addBedCalled = false;
      Offset? tapOffset;

      await tester.pumpWidget(createWidgetUnderTest(
        beds: [], // No existing beds
        onAdd: (offset) {
          addBedCalled = true;
          tapOffset = offset;
        },
      ));

      // Tap on empty space (center of the widget)
      await tester.tapAt(tester.getCenter(find.byType(GardenGrid)));
      await tester.pump();

      expect(addBedCalled, isTrue);
      expect(tapOffset, isNotNull);
    });

    testWidgets('should display different bed status colors', (tester) async {
      final now = DateTime.now();

      // Create beds with different harvest dates for different statuses
      final healthyBed = BedWithPlanting(
        bed: testBeds.first.bed,
        planting: testBeds.first.planting!.copyWith(
          harvestEstimate:
              now.add(const Duration(days: 30)), // More than 7 days = healthy
        ),
        crop: testBeds.first.crop,
      );

      final warningBed = BedWithPlanting(
        bed: testBeds.first.bed.copyWith(id: 'bed-2', x: 4),
        planting: testBeds.first.planting!.copyWith(
          id: 'planting-2',
          harvestEstimate: now.add(const Duration(days: 5)), // 5 days = warning
        ),
        crop: testBeds.first.crop,
      );

      final criticalBed = BedWithPlanting(
        bed: testBeds.first.bed.copyWith(id: 'bed-3', x: 6),
        planting: testBeds.first.planting!.copyWith(
          id: 'planting-3',
          harvestEstimate:
              now.subtract(const Duration(days: 2)), // Past due = critical
        ),
        crop: testBeds.first.crop,
      );

      final emptyBed = BedWithPlanting(
        bed: testBeds.first.bed.copyWith(id: 'bed-4', x: 8),
        planting: null,
        crop: null,
      );

      await tester.pumpWidget(createWidgetUnderTest(
        beds: [healthyBed, warningBed, criticalBed, emptyBed],
      ));

      // All beds should be rendered
      expect(find.text('Tomate'), findsNWidgets(3)); // 3 beds with crops
      expect(find.byType(Container), findsWidgets); // All bed containers
    });

    testWidgets('should display harvest countdown', (tester) async {
      final now = DateTime.now();
      final bedWithTodayHarvest = BedWithPlanting(
        bed: testBeds.first.bed,
        planting: testBeds.first.planting!.copyWith(
          harvestEstimate: now, // Harvest today
        ),
        crop: testBeds.first.crop,
      );

      await tester.pumpWidget(createWidgetUnderTest(
        beds: [bedWithTodayHarvest],
      ));

      expect(find.text('Hoje!'), findsOneWidget);
    });

    testWidgets('should display quantity indicator', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('4'), findsOneWidget); // quantity from test data
    });

    testWidgets('should handle empty bed list', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(beds: []));

      // Plot info should still be visible
      expect(find.text('Test Garden Plot'), findsOneWidget);

      // No bed widgets should be rendered
      expect(find.text('Tomate'), findsNothing);
    });

    testWidgets('should handle different crop names based on locale',
        (tester) async {
      // Create widget with English locale
      final widget = MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider(
            create: (_) => LocaleProvider()..setLocale(const Locale('en')),
            child: GardenGrid(
              plot: testPlot,
              beds: testBeds,
              onBedTapped: onBedTapped,
              onAddBed: onAddBed,
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Should show English name
      expect(find.text('Tomato'), findsOneWidget);
      expect(find.text('Tomate'), findsNothing);
    });

    testWidgets('should handle overdue tasks properly', (tester) async {
      final now = DateTime.now();
      final overdueBed = BedWithPlanting(
        bed: testBeds.first.bed,
        planting: testBeds.first.planting!.copyWith(
          harvestEstimate:
              now.subtract(const Duration(days: 5)), // 5 days overdue
        ),
        crop: testBeds.first.crop,
      );

      await tester.pumpWidget(createWidgetUnderTest(beds: [overdueBed]));

      expect(find.text('Atrasado'), findsOneWidget);
    });

    testWidgets('should center view on garden on initialization',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Allow animation to complete
      await tester.pumpAndSettle();

      // Verify InteractiveViewer is present and functional
      final interactiveViewer =
          tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
      expect(interactiveViewer, isNotNull);
      expect(interactiveViewer.minScale, 0.3);
      expect(interactiveViewer.maxScale, 5.0);
    });
  });

  group('GardenBackgroundPainter', () {
    testWidgets('should paint grid lines and measurements', (tester) async {
      final plot = Plot(
        id: 'test-plot',
        farmId: 'test-farm',
        label: 'Test Plot',
        lengthM: 5.0,
        widthM: 4.0,
        pathGapM: 0.5,
        createdAt: DateTime.now(),
      );

      final painter = GardenBackgroundPainter(
        plot: plot,
        scale: 50.0,
      );

      // Test that painter can be created without errors
      expect(painter, isNotNull);
      expect(painter.plot, equals(plot));
      expect(painter.scale, 50.0);

      // Test shouldRepaint
      expect(painter.shouldRepaint(painter), isTrue);
    });
  });
}
