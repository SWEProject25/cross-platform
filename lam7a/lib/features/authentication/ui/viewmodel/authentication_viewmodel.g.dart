// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthenticationViewmodel)
const authenticationViewmodelProvider = AuthenticationViewmodelProvider._();

final class AuthenticationViewmodelProvider
    extends $NotifierProvider<AuthenticationViewmodel, AuthenticationState> {
  const AuthenticationViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationViewmodelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationViewmodelHash();

  @$internal
  @override
  AuthenticationViewmodel create() => AuthenticationViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticationState>(value),
    );
  }
}

String _$authenticationViewmodelHash() =>
    r'bae9fe3a56762e03f023b536dd27a74be0b0ab04';

abstract class _$AuthenticationViewmodel
    extends $Notifier<AuthenticationState> {
  AuthenticationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthenticationState, AuthenticationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthenticationState, AuthenticationState>,
              AuthenticationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
