import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/core/presentation/screens/splash_screen.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('renders app display name', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

      expect(find.text('{{app_display_name}}'), findsOneWidget);
    });

    testWidgets('renders loading indicator', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
