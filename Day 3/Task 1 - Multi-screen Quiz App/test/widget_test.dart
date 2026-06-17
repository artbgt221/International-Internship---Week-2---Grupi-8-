import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_quiz_app/main.dart';

void main() {
  testWidgets('completes quiz and restarts', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    await tester.tap(find.widgetWithText(OutlinedButton, 'Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Column'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Schedules a widget rebuild'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'ListView'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'ThemeData'));
    await tester.pumpAndSettle();

    expect(find.text('Final Score'), findsOneWidget);
    expect(find.byKey(const Key('scoreText')), findsOneWidget);
    expect(find.text('5 / 5'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Restart quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 5'), findsOneWidget);
  });
}
