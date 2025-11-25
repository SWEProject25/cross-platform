import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_body_input_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_header_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_toolbar_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddTweetHeaderWidget', () {
    testWidgets('calls onCancel when not loading', (WidgetTester tester) async {
      var canceled = false;
      var posted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTweetHeaderWidget(
              onCancel: () => canceled = true,
              onPost: () => posted = true,
              canPost: false,
              isLoading: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(canceled, true);
      expect(posted, false);
    });

    testWidgets('disables actions when loading', (WidgetTester tester) async {
      var canceled = false;
      var posted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTweetHeaderWidget(
              onCancel: () => canceled = true,
              onPost: () => posted = true,
              canPost: true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // While loading, the Post button shows a spinner instead of text
      expect(find.text('Post'), findsNothing);

      expect(canceled, false);
      expect(posted, false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls onPost when canPost and not loading',
        (WidgetTester tester) async {
      var posted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTweetHeaderWidget(
              onCancel: () {},
              onPost: () => posted = true,
              canPost: true,
              isLoading: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Post'));
      await tester.pump();

      expect(posted, true);
    });
  });

  group('AddTweetBodyInputWidget', () {
    testWidgets('renders avatar and calls onChanged',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      String? lastValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTweetBodyInputWidget(
              controller: controller,
              onChanged: (value) => lastValue = value,
              maxLength: 10,
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text("What's happening?"), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(lastValue, 'hello');
    });
  });

  group('AddTweetToolbarWidget', () {
    testWidgets('invokes callbacks for toolbar buttons',
        (WidgetTester tester) async {
      var imageTapped = false;
      var gifTapped = false;
      var pollTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTweetToolbarWidget(
              onImagePick: () => imageTapped = true,
              onGifPick: () => gifTapped = true,
              onPollCreate: () => pollTapped = true,
            ),
          ),
        ),
      );

      // There are three icons: image, video, poll
      final icons = find.byIcon(Icons.image_outlined);
      expect(icons, findsOneWidget);

      await tester.tap(find.byIcon(Icons.image_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.videocam_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.poll_outlined));
      await tester.pump();

      expect(imageTapped, true);
      expect(gifTapped, true);
      expect(pollTapped, true);
    });
  });
}
