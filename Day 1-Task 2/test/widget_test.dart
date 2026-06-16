import 'package:day1_task2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('llogarit mesataren dhe shfaq statusin Kalon',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GradeCalculatorApp());

    await tester.enterText(find.byType(TextField).at(0), '5');
    await tester.enterText(find.byType(TextField).at(1), '4');
    await tester.enterText(find.byType(TextField).at(2), '3');
    await tester.tap(find.text('Llogarit'));
    await tester.pump();

    expect(find.text('4.00'), findsOneWidget);
    expect(find.text('Kalon'), findsOneWidget);
  });
}
