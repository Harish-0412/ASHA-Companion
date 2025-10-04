// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asha_app/asha_ehr_app.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ASHAEHRApp());

    // Verify that our app title appears
    expect(find.text('ASHA Health Companion'), findsOneWidget);
    
    // Verify the app renders without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
