import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_body_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_detailed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_summary.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Ignore network image HTTP failures in tests (avatar & fullscreen previews)
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is NetworkImageLoadException) {
      // In widget tests, real HTTP is blocked; avoid failing tests on 400s
      return;
    }
    FlutterError.presentError(details);
  };

  final baseTweet = TweetModel(
    id: 't1',
    body: 'Hello #world from @tester',
    date: DateTime(2025, 1, 1),
    userId: 'u1',
    username: 'tester',
    authorName: 'Test User',
    authorProfileImage: null,
  );

  TweetState buildTweetState(TweetModel tweet) {
    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.data(tweet),
    );
  }

  group('StyledTweetText', () {
    testWidgets('renders text with hashtags and mentions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const StyledTweetText(
              text: 'Hello #flutter from @dart',
              maxLines: 2,
            ),
          ),
        ),
      );

      // StyledTweetText uses RichText + TextSpan; inspect spans instead of Text widgets
      final richText = tester.widget<RichText>(find.byType(RichText));
      final TextSpan rootSpan = richText.text as TextSpan;
      final List<InlineSpan> children =
          rootSpan.children ?? const <InlineSpan>[];

      expect(children.length, 4);

      expect((children[0] as TextSpan).text, 'Hello ');
      expect((children[1] as TextSpan).text, '#flutter');
      expect((children[2] as TextSpan).text, ' from ');
      expect((children[3] as TextSpan).text, '@dart');

      // Hashtags and mentions should be styled in grey
      final mentionStyle = (children[1] as TextSpan).style!;
      final userStyle = (children[3] as TextSpan).style!;
      expect(mentionStyle.color, Colors.grey);
      expect(userStyle.color, Colors.grey);
    });
  });

  group('Tweet user info widgets', () {
    testWidgets('TweetUserSummaryInfo prefers fallback tweet', (
      WidgetTester tester,
    ) async {
      final tweetState = buildTweetState(
        baseTweet.copyWith(username: 'wrong', authorName: 'Wrong User'),
      );

      final fallback = baseTweet.copyWith(
        username: 'correct',
        authorName: 'Correct User',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  TweetUserSummaryInfo(
                    tweetState: tweetState,
                    daysPosted: 3,
                    fallbackTweet: fallback,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Correct User'), findsOneWidget);
      expect(find.text('@correct · '), findsOneWidget);
      expect(find.text('3d'), findsOneWidget);
    });

    testWidgets('TweetUserInfoDetailed shows username and display name', (
      WidgetTester tester,
    ) async {
      final tweetState = buildTweetState(baseTweet);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: TweetUserInfoDetailed(tweetState: tweetState)),
          ),
        ),
      );

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('@tester'), findsOneWidget);
      expect(find.text('Follow'), findsOneWidget);
    });
  });

  group('TweetDetailedBodyWidget', () {
    testWidgets('renders body text when tweet is present', (
      WidgetTester tester,
    ) async {
      final tweetState = buildTweetState(
        baseTweet.copyWith(body: 'Detailed body'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TweetDetailedBodyWidget(tweetState: tweetState)),
        ),
      );

      expect(find.text('Detailed body'), findsOneWidget);
    });

    testWidgets('shows not found message when tweet value is null', (
      WidgetTester tester,
    ) async {
      // Use a loading AsyncValue so that tweetState.tweet.value is null
      final state = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: const AsyncValue<TweetModel>.loading(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TweetDetailedBodyWidget(tweetState: state)),
        ),
      );

      expect(find.textContaining('Tweet not found'), findsOneWidget);
    });
  });

  group('FullScreenMediaViewer', () {
    testWidgets('closes when close button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FullScreenMediaViewer(
                            url: 'https://example.com/image.png',
                            isVideo: false,
                          ),
                        ),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(FullScreenMediaViewer), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(FullScreenMediaViewer), findsNothing);
    });
  });
}
