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
    extends $AsyncNotifierProvider<TweetViewModel, TweetState> {
  const TweetViewModelProvider._({
    required TweetViewModelFamily super.from,
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  TweetViewModel create() => TweetViewModel();

  @override
  bool operator ==(Object other) {
    return other is TweetViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tweetViewModelHash() => r'38c88d9d5145768a26da3aabccda74d987b90a21';

final class TweetViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          TweetViewModel,
          AsyncValue<TweetState>,
          TweetState,
          FutureOr<TweetState>,
          String
        > {
  const TweetViewModelFamily._()
    : super(
        retry: null,
        name: r'tweetViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TweetViewModelProvider call(String tweetId) =>
      TweetViewModelProvider._(argument: tweetId, from: this);

  @override
  String toString() => r'tweetViewModelProvider';
}

abstract class _$TweetViewModel extends $AsyncNotifier<TweetState> {
  late final _$args = ref.$arg as String;
  String get tweetId => _$args;

  FutureOr<TweetState> build(String tweetId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<TweetState>, TweetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TweetState>, TweetState>,
              AsyncValue<TweetState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
