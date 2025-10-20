// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TweetViewModel)
const tweetViewModelProvider = TweetViewModelFamily._();

final class TweetViewModelProvider
    extends $NotifierProvider<TweetViewModel, TweetModel> {
  const TweetViewModelProvider._({
    required TweetViewModelFamily super.from,
    required (String, {TweetModel? initialTweet}) super.argument,
  }) : super(
         retry: null,
         name: r'tweetViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tweetViewModelHash();

  @override
  String toString() {
    return r'tweetViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TweetViewModel create() => TweetViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TweetModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TweetModel>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TweetViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tweetViewModelHash() => r'0ff72944f9b4738ff66a4c19b896245a11a024dd';

final class TweetViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          TweetViewModel,
          TweetModel,
          TweetModel,
          TweetModel,
          (String, {TweetModel? initialTweet})
        > {
  const TweetViewModelFamily._()
    : super(
        retry: null,
        name: r'tweetViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TweetViewModelProvider call(String tweetId, {TweetModel? initialTweet}) =>
      TweetViewModelProvider._(
        argument: (tweetId, initialTweet: initialTweet),
        from: this,
      );

  @override
  String toString() => r'tweetViewModelProvider';
}

abstract class _$TweetViewModel extends $Notifier<TweetModel> {
  late final _$args = ref.$arg as (String, {TweetModel? initialTweet});
  String get tweetId => _$args.$1;
  TweetModel? get initialTweet => _$args.initialTweet;

  TweetModel build(String tweetId, {TweetModel? initialTweet});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, initialTweet: _$args.initialTweet);
    final ref = this.ref as $Ref<TweetModel, TweetModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TweetModel, TweetModel>,
              TweetModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
