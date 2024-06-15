import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:productivity_app/CHAT/widgets/message_caard_user.dart';
import 'package:productivity_app/models/message.dart';

void main() {
  testWidgets('MyMessageCard displays message, date, and has amber color',
      (WidgetTester tester) async {
    // Define the test data
    const testMessage = 'Test Message';
    const testDate = '12:00 PM';
    const testType = MessageEnum.text; // Replace with your actual enum value
    const testUsername = 'Username';
    const testRepliedText = '';
    const testRepliedMessageType =
        MessageEnum.text; // Replace with your actual enum value
    const testIsSeen = true;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyMessageCard(
            message: testMessage,
            date: testDate,
            type: testType,
            onLeftSwipe: () {},
            repliedText: testRepliedText,
            username: testUsername,
            repliedMessageType: testRepliedMessageType,
            isSeen: testIsSeen,
          ),
        ),
      ),
    );

    // Verify if the message is displayed
    expect(find.text(testMessage), findsOneWidget);

    // Verify if the date is displayed
    expect(find.text(testDate), findsOneWidget);

    // Verify if the card is amber
    final cardFinder = find.byType(Card);
    final cardWidget = tester.widget<Card>(cardFinder);
    expect((cardWidget.color), Colors.amber);
  });

  testWidgets('MyMessageCard displays seen icon correctly',
      (WidgetTester tester) async {
    // Define the test data for seen
    const testMessage = 'Test Message';
    const testDate = '12:00 PM';
    const testType = MessageEnum.text; // Replace with your actual enum value
    const testUsername = 'Username';
    const testRepliedText = '';
    const testRepliedMessageType =
        MessageEnum.text; // Replace with your actual enum value
    const testIsSeen = true;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyMessageCard(
            message: testMessage,
            date: testDate,
            type: testType,
            onLeftSwipe: () {},
            repliedText: testRepliedText,
            username: testUsername,
            repliedMessageType: testRepliedMessageType,
            isSeen: testIsSeen,
          ),
        ),
      ),
    );

    // Verify if the seen icon is displayed
    expect(find.byIcon(Icons.done_all), findsOneWidget);
    expect(find.byIcon(Icons.done), findsNothing);
  });

  testWidgets('MyMessageCard displays unseen icon correctly',
      (WidgetTester tester) async {
    // Define the test data for unseen
    const testMessage = 'Test Message';
    const testDate = '12:00 PM';
    const testType = MessageEnum.text; // Replace with your actual enum value
    const testUsername = 'Username';
    const testRepliedText = '';
    const testRepliedMessageType =
        MessageEnum.text; // Replace with your actual enum value
    const testIsSeen = false;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyMessageCard(
            message: testMessage,
            date: testDate,
            type: testType,
            onLeftSwipe: () {},
            repliedText: testRepliedText,
            username: testUsername,
            repliedMessageType: testRepliedMessageType,
            isSeen: testIsSeen,
          ),
        ),
      ),
    );

    // Verify if the unseen icon is displayed
    expect(find.byIcon(Icons.done), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsNothing);
  });
}
