// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focuslog/main.dart';


void main() {
  testWidgets('FocusLog app launches and shows main UI',
          (WidgetTester tester) async {
        // Build app
        await tester.pumpWidget(const FocusLogApp());

        // Verify app title
        expect(find.text('FocusLog'), findsOneWidget);

        // Verify start focus button
        expect(find.text('Start Focus'), findsOneWidget);

        // Verify empty state
        expect(find.text('No sessions yet'), findsOneWidget);
      });
}
