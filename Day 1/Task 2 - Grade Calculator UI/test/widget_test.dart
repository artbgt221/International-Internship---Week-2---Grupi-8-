import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_calculator_ui/main.dart';

void main() {
  testWidgets('calculates average with two decimal places', (WidgetTester tester) async {
    await tester.pumpWidget(const GradeCalculatorApp());

    await tester.enterText(find.byKey(const Key('gradeField0')), '80');
    await tester.enterText(find.byKey(const Key('gradeField1')), '71');
    await tester.enterText(find.byKey(const Key('gradeField2')), '93');
    await tester.tap(find.widgetWithText(FilledButton, 'Calculate average'));
    await tester.pump();

    expect(find.text('Average: 81.33'), findsOneWidget);
    expect(find.text('Status: Pass'), findsOneWidget);
  });

  testWidgets('shows validation errors for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(const GradeCalculatorApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Calculate average'));
    await tester.pump();

    expect(find.text('Enter a grade'), findsNWidgets(3));
  });
}
