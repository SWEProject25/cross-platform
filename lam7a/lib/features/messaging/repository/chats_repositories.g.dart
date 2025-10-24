// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatsRepository)
const chatsRepositoryProvider = ChatsRepositoryProvider._();

final class ChatsRepositoryProvider
    extends
        $FunctionalProvider<ChatsRepository, ChatsRepository, ChatsRepository>
    with $Provider<ChatsRepository> {
  const ChatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsRepository create(Ref ref) {
    return chatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsRepository>(value),
    );
  }
}

String _$chatsRepositoryHash() => r'cb257a8f595d1b482504fb247b8451644aa21949';
