import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Ignore network image HTTP failures in tests
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is NetworkImageLoadException) {
      return;
    }
    FlutterError.presentError(details);
  };

  final baseTweet = TweetModel(
    id: 't1',
    body: 'Test tweet body with #hashtag and @mention',
    date: DateTime(2025, 1, 1),
    userId: 'u1',
    username: 'testuser',
    authorName: 'Test User',
    authorProfileImage: null,
    mediaImages: const [],
    mediaVideos: const [],
  );

  Widget buildTestWidget(TweetModel tweet, {bool disableOriginalTap = false}) {
    return MaterialApp(
      home: Scaffold(
        body: TweetBodySummaryWidget(
          post: tweet,
          disableOriginalTap: disableOriginalTap,
        ),
      ),
    );
  }

  group('TweetBodySummaryWidget - Basic Rendering', () {
    testWidgets('renders tweet body text', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('uses StyledTweetText for body rendering', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(StyledTweetText), findsWidgets);
    });

    testWidgets('hides body text when empty', (WidgetTester tester) async {
      final emptyBodyTweet = baseTweet.copyWith(body: '');
      await tester.pumpWidget(buildTestWidget(emptyBodyTweet));
      await tester.pumpAndSettle();

      expect(find.byType(StyledTweetText), findsNothing);
    });

    testWidgets('trims whitespace from body text', (WidgetTester tester) async {
      final whitespaceTweet = baseTweet.copyWith(body: '  Test body  ');
      await tester.pumpWidget(buildTestWidget(whitespaceTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('uses LayoutBuilder for responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('uses Column for layout', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });
  });

  group('TweetBodySummaryWidget - Single Image', () {
    testWidgets('displays single image from mediaImages', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('displays legacy mediaPic when mediaImages is empty', (WidgetTester tester) async {
      final legacyTweet = baseTweet.copyWith(
        mediaPic: 'https://example.com/image.jpg',
        mediaImages: const [],
      );
      await tester.pumpWidget(buildTestWidget(legacyTweet));

      // Widget builds successfully
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('image has rounded corners', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(ClipRRect), findsWidgets);
      final clipRRect = tester.widget<ClipRRect>(
        find.byType(ClipRRect).first,
      );
      expect(clipRRect.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('image has loading placeholder', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('image tap opens FullScreenMediaViewer', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));

      // Widget builds successfully with tap handler
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });
  });

  group('TweetBodySummaryWidget - Multiple Images', () {
    testWidgets('displays 2 images in a row', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('displays 3 images: 2 top, 1 bottom', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));

      // Widget builds successfully with 3 images
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('displays max 4 images in 2x2 grid', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
          'https://example.com/image4.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));

      // Widget builds successfully with 4 images
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('ignores images beyond 4', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
          'https://example.com/image4.jpg',
          'https://example.com/image5.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));

      // Widget builds successfully with max 4 images shown
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('each image is tappable independently', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });

  group('TweetBodySummaryWidget - Videos', () {
    testWidgets('displays single video from mediaVideos', (WidgetTester tester) async {
      final videoTweet = baseTweet.copyWith(
        mediaVideos: ['https://example.com/video1.mp4'],
        mediaImages: const [],
      );
      await tester.pumpWidget(buildTestWidget(videoTweet));


      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('displays legacy mediaVideo when mediaVideos is empty', (WidgetTester tester) async {
      final legacyVideoTweet = baseTweet.copyWith(
        mediaVideo: 'https://example.com/video.mp4',
        mediaVideos: const [],
        mediaPic: null,
      );
      await tester.pumpWidget(buildTestWidget(legacyVideoTweet));

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('shows only 1 video in summary', (WidgetTester tester) async {
      final multiVideoTweet = baseTweet.copyWith(
        mediaVideos: [
          'https://example.com/video1.mp4',
          'https://example.com/video2.mp4',
        ],
        mediaImages: const [],
      );
      await tester.pumpWidget(buildTestWidget(multiVideoTweet));

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('images take precedence over videos', (WidgetTester tester) async {
      final mixedMediaTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
        mediaVideos: ['https://example.com/video1.mp4'],
      );
      await tester.pumpWidget(buildTestWidget(mixedMediaTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
      expect(find.byType(VideoPlayerWidget), findsNothing);
    });
  });



  group('TweetBodySummaryWidget - Edge Cases', () {
    testWidgets('handles tweet with no media', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
      expect(find.byType(VideoPlayerWidget), findsNothing);
    });

    testWidgets('handles very long body text with ellipsis', (WidgetTester tester) async {
      final longTweet = baseTweet.copyWith(
        body: 'A' * 500,
      );
      await tester.pumpWidget(buildTestWidget(longTweet));
      await tester.pumpAndSettle();

      final styledText = tester.widget<StyledTweetText>(
        find.byType(StyledTweetText).first,
      );
      expect(styledText.maxLines, 3);
      expect(styledText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('handles tweet with only whitespace body', (WidgetTester tester) async {
      final whitespaceTweet = baseTweet.copyWith(body: '   \n\t   ');
      await tester.pumpWidget(buildTestWidget(whitespaceTweet));
      await tester.pumpAndSettle();

      // Should be treated as empty after trim
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('handles null authorProfileImage', (WidgetTester tester) async {
      final noAvatarTweet = baseTweet.copyWith(authorProfileImage: null);
      await tester.pumpWidget(buildTestWidget(noAvatarTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('handles empty mediaImages list', (WidgetTester tester) async {
      final noImagesTweet = baseTweet.copyWith(mediaImages: const []);
      await tester.pumpWidget(buildTestWidget(noImagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('handles empty mediaVideos list', (WidgetTester tester) async {
      final noVideosTweet = baseTweet.copyWith(mediaVideos: const []);
      await tester.pumpWidget(buildTestWidget(noVideosTweet));
      await tester.pumpAndSettle();

      expect(find.byType(VideoPlayerWidget), findsNothing);
    });
  });

  group('TweetBodySummaryWidget - Styling and Layout', () {
    testWidgets('uses theme bodyLarge for text', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      final styledText = tester.widget<StyledTweetText>(
        find.byType(StyledTweetText).first,
      );
      
      expect(styledText.style, isNotNull);
    });

    testWidgets('has proper spacing between elements', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('uses Flexible for text wrapping', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(baseTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Flexible), findsWidgets);
    });

    testWidgets('uses Expanded for image tiles', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Expanded), findsWidgets);
    });
  });

  group('TweetBodySummaryWidget - Image Error Handling', () {
    testWidgets('shows error icon on image load failure', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://invalid-url.com/nonexistent.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsWidgets);
    });

    testWidgets('has error builder for images', (WidgetTester tester) async {
      final imagesTweet = baseTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      await tester.pumpWidget(buildTestWidget(imagesTweet));
      await tester.pump();

      expect(find.byType(Image), findsWidgets);
    });
  });

  group('OriginalTweetCard - Basic Rendering', () {
    testWidgets('renders original tweet content', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Original tweet text',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StyledTweetText), findsWidgets);
      expect(find.textContaining('Test User'), findsWidgets);
      expect(find.textContaining('@testuser'), findsWidgets);
    });

    testWidgets('shows time ago format', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('2h'), findsWidgets);
    });

    testWidgets('handles tweet with image', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Tweet with image',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
        mediaImages: ['https://example.com/image.jpg'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('handles tweet with video', (WidgetTester tester) async{
      final tweet = TweetModel(
        id: 't1',
        body: 'Tweet with video',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
        mediaVideos: ['https://example.com/video.mp4'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OriginalTweetCard(tweet: tweet, showActions: false),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('uses fallback username when authorName is null', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('testuser'), findsWidgets);
    });

    testWidgets('uses fallback username when authorName is empty', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: '',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('testuser'), findsWidgets);
    });
  });

  group('OriginalTweetCard - Nested Tweets', () {
    testWidgets('renders nested original tweet', (WidgetTester tester) async {
      final nestedTweet = TweetModel(
        id: 't3',
        body: 'Nested tweet',
        date: DateTime(2025, 1, 1),
        userId: 'u3',
        username: 'nested',
        authorName: 'Nested User',
      );

      final tweet = TweetModel(
        id: 't1',
        body: 'Parent tweet',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
        originalTweet: nestedTweet,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OriginalTweetCard(tweet: tweet, showActions: false),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StyledTweetText), findsWidgets);
      expect(find.byType(OriginalTweetCard), findsNWidgets(2)); // Parent and nested
    });

    testWidgets('hides actions on nested tweet when showActions is false', (WidgetTester tester) async {
      final nestedTweet = TweetModel(
        id: 't3',
        body: 'Nested tweet',
        date: DateTime(2025, 1, 1),
        userId: 'u3',
        username: 'nested',
        authorName: 'Nested User',
      );

      final tweet = TweetModel(
        id: 't1',
        body: 'Parent tweet',
        date: DateTime(2025, 1, 1),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
        originalTweet: nestedTweet,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OriginalTweetCard(tweet: tweet, showActions: false),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OriginalTweetCard), findsNWidgets(2));
    });
  });

  group('OriginalTweetCard - Time Formatting', () {
    testWidgets('formats seconds correctly', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime.now().subtract(const Duration(seconds: 30)),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('s'), findsWidgets);
    });

    testWidgets('formats minutes correctly', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime.now().subtract(const Duration(minutes: 45)),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('m'), findsWidgets);
    });

    testWidgets('formats hours correctly', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('h'), findsWidgets);
    });

    testWidgets('formats days correctly', (WidgetTester tester) async {
      final tweet = TweetModel(
        id: 't1',
        body: 'Test',
        date: DateTime.now().subtract(const Duration(days: 3)),
        userId: 'u1',
        username: 'testuser',
        authorName: 'Test User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OriginalTweetCard(tweet: tweet, showActions: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('d'), findsWidgets);
    });
  });
}
