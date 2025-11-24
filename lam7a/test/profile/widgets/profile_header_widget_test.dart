import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:lam7a/features/profile/ui/widgets/profile_header_widget.dart';
import '../helpers/profile_test_helpers.dart';

void main() {
  testWidgets("ProfileHeaderWidget shows name, handle & follower counts",
      (tester) async {
    final model = makeTestModel();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeaderWidget(
              profile: model,
              isOwnProfile: true,
              onEdited: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Basic info
      expect(find.text("hossam mohamed"), findsOneWidget);
      expect(find.text("@hossam.ho8814"), findsOneWidget);

      // Followers RichText finder
      final followersRichText = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final text = widget.text.toPlainText();
          return text.contains("3") && text.contains("Followers");
        }
        return false;
      });

      // Following RichText finder
      final followingRichText = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final text = widget.text.toPlainText();
          return text.contains("7") && text.contains("Following");
        }
        return false;
      });

      expect(followersRichText, findsOneWidget);
      expect(followingRichText, findsOneWidget);

      expect(find.text("Edit profile"), findsOneWidget);
    });
  });
}
