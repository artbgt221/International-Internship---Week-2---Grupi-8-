import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_form/main.dart';

void main() {
  testWidgets('shows validation errors for invalid registration', (WidgetTester tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await tester.enterText(find.byKey(const Key('emailField')), 'not-email');
    await tester.enterText(find.byKey(const Key('passwordField')), 'short');
    await tester.tap(find.widgetWithText(FilledButton, 'Register'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
  });

  testWidgets('shows confirmation dialog after valid registration', (WidgetTester tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await tester.enterText(find.byKey(const Key('nameField')), 'Nora Varga');
    await tester.enterText(find.byKey(const Key('emailField')), 'nora@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'securePass1');
    await tester.tap(find.widgetWithText(FilledButton, 'Register'));
    await tester.pumpAndSettle();

    expect(find.text('Registration complete'), findsOneWidget);
    expect(find.text('Name: Nora Varga'), findsOneWidget);
    expect(find.text('Email: nora@example.com'), findsOneWidget);
    expect(find.text('Role: Student'), findsOneWidget);
  });
}
