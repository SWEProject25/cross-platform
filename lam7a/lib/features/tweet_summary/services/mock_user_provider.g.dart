// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userById)
const userByIdProvider = UserByIdFamily._();

final class UserByIdProvider
    extends
        $FunctionalProvider<AsyncValue<UserProf>, UserProf, FutureOr<UserProf>>
    with $FutureModifier<UserProf>, $FutureProvider<UserProf> {
  const UserByIdProvider._({
    required UserByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userByIdHash();

  @override
  String toString() {
    return r'userByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserProf> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserProf> create(Ref ref) {
    final argument = this.argument as String;
    return userById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userByIdHash() => r'd5935b3a840304071bc2d30fd1fff131bfbdd214';

final class UserByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserProf>, String> {
  const UserByIdFamily._()
    : super(
        retry: null,
        name: r'userByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserByIdProvider call(String userId) =>
      UserByIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'userByIdProvider';
}
