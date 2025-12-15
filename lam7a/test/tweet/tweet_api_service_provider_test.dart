import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  test('tweetsApiService provider returns TweetsApiServiceImpl', () async {
    SharedPreferences.setMockInitialValues({});
    final mockApiService = MockApiService();

    final container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(mockApiService),
      ],
    );

    final service = container.read(tweetsApiServiceProvider);

    expect(service, isA<TweetsApiServiceImpl>());
  });
}
