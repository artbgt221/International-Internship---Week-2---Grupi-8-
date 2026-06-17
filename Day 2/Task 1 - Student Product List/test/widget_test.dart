import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_product_list/main.dart';

void main() {
  testWidgets('adds a student with valid input', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentListApp());

    await tester.enterText(find.byKey(const Key('nameField')), 'Lina Torres');
    await tester.enterText(find.byKey(const Key('emailField')), 'lina@example.com');
    await tester.enterText(find.byKey(const Key('programField')), 'Design');
    await tester.tap(find.widgetWithText(FilledButton, 'Add student'));
    await tester.pump();

    expect(find.text('Lina Torres'), findsOneWidget);
    expect(find.text('Students (3)'), findsOneWidget);
  });

  testWidgets('validates empty and invalid email fields', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentListApp());

    await tester.enterText(find.byKey(const Key('emailField')), 'wrong-email');
    await tester.tap(find.widgetWithText(FilledButton, 'Add student'));
    await tester.pump();

    expect(find.text('This field is required'), findsNWidgets(2));
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
