// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tweetRepository)
const tweetRepositoryProvider = TweetRepositoryProvider._();

final class TweetRepositoryProvider
    extends
        $FunctionalProvider<TweetRepository, TweetRepository, TweetRepository>
    with $Provider<TweetRepository> {
  const TweetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tweetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tweetRepositoryHash();

  @$internal
  @override
  $ProviderElement<TweetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TweetRepository create(Ref ref) {
    return tweetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TweetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TweetRepository>(value),
    );
  }
}

String _$tweetRepositoryHash() => r'a29e83d2a58eb4324d517b057c8ae033367df023';
