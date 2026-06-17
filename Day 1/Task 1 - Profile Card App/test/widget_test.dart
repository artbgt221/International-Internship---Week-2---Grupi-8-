import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card_app/main.dart';

void main() {
  testWidgets('updates profile status when button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    expect(find.text('Maya Chen'), findsOneWidget);
    expect(find.text('Open to international internships'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Update status'));
    await tester.pump();

    expect(find.text('Currently building Flutter apps'), findsWidgets);
  });
}
