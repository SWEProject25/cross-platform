// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(usersRepository)
const usersRepositoryProvider = UsersRepositoryProvider._();

final class UsersRepositoryProvider
    extends
        $FunctionalProvider<
          UserRelationsRepository,
          UserRelationsRepository,
          UserRelationsRepository
        >
    with $Provider<UserRelationsRepository> {
  const UsersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRelationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRelationsRepository create(Ref ref) {
    return usersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRelationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRelationsRepository>(value),
    );
  }
}

String _$usersRepositoryHash() => r'ee7a60904bd0f92cf842c48996b67ba2c87850ab';
