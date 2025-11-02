// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myUserRepository)
const myUserRepositoryProvider = MyUserRepositoryProvider._();

final class MyUserRepositoryProvider
    extends
        $FunctionalProvider<
          AccountSettingsRepository,
          AccountSettingsRepository,
          AccountSettingsRepository
        >
    with $Provider<AccountSettingsRepository> {
  const MyUserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myUserRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myUserRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountSettingsRepository create(Ref ref) {
    return myUserRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountSettingsRepository>(value),
    );
  }
}

String _$myUserRepositoryHash() => r'c8a8b89c1f44ea86dbd9d6ff59ebd00bff89a656';
