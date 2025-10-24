// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loginFlow)
const loginFlowProvider = LoginFlowProvider._();

final class LoginFlowProvider
    extends $FunctionalProvider<List<Widget>, List<Widget>, List<Widget>>
    with $Provider<List<Widget>> {
  const LoginFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginFlowHash();

  @$internal
  @override
  $ProviderElement<List<Widget>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Widget> create(Ref ref) {
    return loginFlow(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Widget> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Widget>>(value),
    );
  }
}

String _$loginFlowHash() => r'057080de99f8567c143958aac207ae8d1da4bd17';

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
        isAutoDispose: true,
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
    r'66464e94fef136f0f2555a87183892f65ceb46c0';

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
