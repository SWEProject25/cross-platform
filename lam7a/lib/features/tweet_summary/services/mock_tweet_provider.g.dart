// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_tweet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///  This replaces `tweetByIdProvider`
/// A single provider managing all mock tweet data.

@ProviderFor(MockTweetRepository)
const mockTweetRepositoryProvider = MockTweetRepositoryProvider._();

///  This replaces `tweetByIdProvider`
/// A single provider managing all mock tweet data.
final class MockTweetRepositoryProvider
    extends $NotifierProvider<MockTweetRepository, void> {
  ///  This replaces `tweetByIdProvider`
  /// A single provider managing all mock tweet data.
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
    r'bfcab7c25893f4a8a1d27ec61fbfa64cae89ff44';

///  This replaces `tweetByIdProvider`
/// A single provider managing all mock tweet data.

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
