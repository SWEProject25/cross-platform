// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_tweet_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MockTweetRepository)
const mockTweetRepositoryProvider = MockTweetRepositoryProvider._();

final class MockTweetRepositoryProvider
    extends $NotifierProvider<MockTweetRepository, void> {
  const MockTweetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockTweetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockTweetRepositoryHash();

  @$internal
  @override
  MockTweetRepository create() => MockTweetRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mockTweetRepositoryHash() =>
    r'948110a5fc84def0a390ca0247b5632247f4ab0d';

abstract class _$MockTweetRepository extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
