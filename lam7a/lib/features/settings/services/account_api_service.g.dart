// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountApiService)
const accountApiServiceProvider = AccountApiServiceProvider._();

final class AccountApiServiceProvider
    extends
        $FunctionalProvider<
          AccountApiService,
          AccountApiService,
          AccountApiService
        >
    with $Provider<AccountApiService> {
  const AccountApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountApiServiceHash();

  @$internal
  @override
  $ProviderElement<AccountApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountApiService create(Ref ref) {
    return accountApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountApiService>(value),
    );
  }
}

String _$accountApiServiceHash() => r'08be13572d34c1c1cd74ab13490b24d0e736341e';

@ProviderFor(accountApiServiceImpl)
const accountApiServiceImplProvider = AccountApiServiceImplProvider._();

final class AccountApiServiceImplProvider
    extends
        $FunctionalProvider<
          AccountApiService,
          AccountApiService,
          AccountApiService
        >
    with $Provider<AccountApiService> {
  const AccountApiServiceImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountApiServiceImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountApiServiceImplHash();

  @$internal
  @override
  $ProviderElement<AccountApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountApiService create(Ref ref) {
    return accountApiServiceImpl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountApiService>(value),
    );
  }
}

String _$accountApiServiceImplHash() =>
    r'84efc58829b23b4223ea2b784ccb061a381de669';
