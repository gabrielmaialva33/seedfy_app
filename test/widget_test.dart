// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seedfy_app/core/providers/locale_provider.dart';
import 'package:seedfy_app/main.dart';

void main() {
  testWidgets('Seedfy app loads correctly', (WidgetTester tester) async {
    // Create a test wrapper with providers
    final testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const SeedfyApp(),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(testApp);

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that the app has loaded (check for MaterialApp)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App title is Seedfy', (WidgetTester tester) async {
    // Test just the MaterialApp configuration without full initialization
    final testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const SeedfyApp(),
    );

    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, equals('Seedfy'));
  });
}
