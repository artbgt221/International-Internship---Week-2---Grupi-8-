import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card_app/main.dart';

void main() {
  testWidgets('profile information and contact button are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    expect(find.text('Rion Krasniqi'), findsOneWidget);
    expect(find.text('Student Developer'), findsOneWidget);
    expect(find.text('Me kontakto'), findsOneWidget);
  });
}
