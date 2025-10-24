// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiClient)
const apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<Openapi, Openapi, Openapi>
    with $Provider<Openapi> {
  const ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<Openapi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Openapi create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Openapi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Openapi>(value),
    );
  }
}

String _$apiClientHash() => r'ef593bb9c4f47a930b9ce522d90724495d99b6b3';
