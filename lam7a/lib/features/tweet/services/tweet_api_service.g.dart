// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tweetsApiService)
const tweetsApiServiceProvider = TweetsApiServiceProvider._();

final class TweetsApiServiceProvider
    extends
        $FunctionalProvider<
          TweetsApiService,
          TweetsApiService,
          TweetsApiService
        >
    with $Provider<TweetsApiService> {
  const TweetsApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tweetsApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tweetsApiServiceHash();

  @$internal
  @override
  $ProviderElement<TweetsApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TweetsApiService create(Ref ref) {
    return tweetsApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TweetsApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TweetsApiService>(value),
    );
  }
}

String _$tweetsApiServiceHash() => r'499fceb69aa9915c525aa8eb6e5159320406c652';
