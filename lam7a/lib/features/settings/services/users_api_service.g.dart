// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(usersApiService)
const usersApiServiceProvider = UsersApiServiceProvider._();

final class UsersApiServiceProvider
    extends
        $FunctionalProvider<UsersApiService, UsersApiService, UsersApiService>
    with $Provider<UsersApiService> {
  const UsersApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersApiServiceHash();

  @$internal
  @override
  $ProviderElement<UsersApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UsersApiService create(Ref ref) {
    return usersApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsersApiService>(value),
    );
  }
}

String _$usersApiServiceHash() => r'ed70c51415edde119bcc4859a02fa2423dfe377a';
