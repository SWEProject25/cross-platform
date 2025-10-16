// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatsApiService)
const chatsApiServiceProvider = ChatsApiServiceProvider._();

final class ChatsApiServiceProvider
    extends
        $FunctionalProvider<ChatsApiService, ChatsApiService, ChatsApiService>
    with $Provider<ChatsApiService> {
  const ChatsApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsApiServiceHash();

  @$internal
  @override
  $ProviderElement<ChatsApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsApiService create(Ref ref) {
    return chatsApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsApiService>(value),
    );
  }
}

String _$chatsApiServiceHash() => r'607c4bb86b4280bba75ff184ba07b3d534a2ccc7';
