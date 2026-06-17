import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_expense_tracker/main.dart';

void main() {
  testWidgets('adds, opens, toggles, and deletes an expense', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Books');
    await tester.enterText(find.byKey(const Key('amountField')), '35.25');
    await tester.enterText(find.byKey(const Key('categoryField')), 'Study');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('\$105.75'), findsOneWidget);

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();

    expect(find.text('Expense Details'), findsOneWidget);
    expect(find.text('Amount: \$35.25'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(find.text('Books marked paid'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pump();

    expect(find.text('Books deleted'), findsOneWidget);
    expect(find.text('Books'), findsNothing);
  });
}
