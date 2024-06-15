import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productivity_app/CHAT/widgets/message_card_others.dart';
import 'package:productivity_app/models/message.dart';

void main() {
  testWidgets('SenderMessageCard displays message, date, and has blue color',
      (WidgetTester tester) async {
    // Define the test data
    const testMessage = 'Test Message';
    const testDate = '12:00 PM';
    const testType = MessageEnum.text; // Replace with your actual enum value
    const testUsername = 'Username';
    const testRepliedText = '';
    const testRepliedMessageType =
        MessageEnum.text; // Replace with your actual enum value

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SenderMessageCard(
            message: testMessage,
            date: testDate,
            type: testType,
            onRightSwipe: () {},
            repliedText: testRepliedText,
            username: testUsername,
            repliedMessageType: testRepliedMessageType,
          ),
        ),
      ),
    );

    // Verify if the message is displayed
    expect(find.text(testMessage), findsOneWidget);

    // Verify if the date is displayed
    expect(find.text(testDate), findsOneWidget);

    // Verify if the card is blue
    final cardFinder = find.byType(Card);
    final cardWidget = tester.widget<Card>(cardFinder);
    expect((cardWidget.color), Colors.blue);
  });
}
