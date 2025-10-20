// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_tweet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tweetById)
const tweetByIdProvider = TweetByIdFamily._();

final class TweetByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<TweetModel>,
          TweetModel,
          FutureOr<TweetModel>
        >
    with $FutureModifier<TweetModel>, $FutureProvider<TweetModel> {
  const TweetByIdProvider._({
    required TweetByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tweetByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tweetByIdHash();

  @override
  String toString() {
    return r'tweetByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TweetModel> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TweetModel> create(Ref ref) {
    final argument = this.argument as String;
    return tweetById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TweetByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tweetByIdHash() => r'14916db1cc5c3dc3c43e5219f698fc86323e297e';

final class TweetByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TweetModel>, String> {
  const TweetByIdFamily._()
    : super(
        retry: null,
        name: r'tweetByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TweetByIdProvider call(String tweetId) =>
      TweetByIdProvider._(argument: tweetId, from: this);

  @override
  String toString() => r'tweetByIdProvider';
}
