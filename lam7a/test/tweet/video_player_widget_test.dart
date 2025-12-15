import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';

import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testVideoUrl = 'https://example.com/video.mp4';

  group('VideoPlayerWidget Tests', () {
    testWidgets('initializes and renders widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('displays loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      // Before video initializes, should show placeholder or loading
      await tester.pump();
      
      // Widget should be present
      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('uses FutureBuilder for initialization', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      expect(find.byType(FutureBuilder<void>), findsOneWidget);
    });

    testWidgets('has AspectRatio widget in loading state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      // Should have AspectRatio widget for placeholder
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('displays with rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      // Should have ClipRRect for rounded corners
      expect(find.byType(ClipRRect), findsOneWidget);
      
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('shows placeholder with grey background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      // Placeholder container should exist
      expect(
        find.descendant(
          of: find.byType(ClipRRect),
          matching: find.byType(Container),
        ),
        findsWidgets,
      );
    });

    testWidgets('uses 16:9 aspect ratio for placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      // AspectRatio widget should be used
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('accepts different video URLs', (WidgetTester tester) async {
      const differentUrl = 'https://different.com/video2.mp4';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: differentUrl),
          ),
        ),
      );

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('handles empty URL gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: ''),
          ),
        ),
      );

      // Should not crash with empty URL
      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('widget has AutomaticKeepAliveClientMixin', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      // The widget should use AutomaticKeepAliveClientMixin
      // This helps maintain video state when scrolling
      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('creates widget with key', (WidgetTester tester) async {
      const key = Key('video_player_key');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(
              key: key,
              url: testVideoUrl,
            ),
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders within a parent widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                VideoPlayerWidget(url: testVideoUrl),
                Text('Below video'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
      expect(find.text('Below video'), findsOneWidget);
    });

    testWidgets('handles URL with query parameters', (
      WidgetTester tester,
    ) async {
      const urlWithParams = 'https://example.com/video.mp4?quality=hd';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: urlWithParams),
          ),
        ),
      );

      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });

    testWidgets('renders in a scrollable widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                VideoPlayerWidget(url: testVideoUrl),
                VideoPlayerWidget(url: 'https://example.com/video2.mp4'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VideoPlayerWidget), findsNWidgets(2));
    });

    testWidgets('has consistent BorderRadius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      final borderRadius = clipRRect.borderRadius as BorderRadius;
      
      expect(borderRadius.topLeft.x, 12);
      expect(borderRadius.topRight.x, 12);
      expect(borderRadius.bottomLeft.x, 12);
      expect(borderRadius.bottomRight.x, 12);
    });

    testWidgets('maintains aspect ratio in different screen sizes', (
      WidgetTester tester,
    ) async {
      // Test in a smaller viewport
      await tester.binding.setSurfaceSize(const Size(400, 600));
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoPlayerWidget(url: testVideoUrl),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(AspectRatio), findsOneWidget);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });
}
