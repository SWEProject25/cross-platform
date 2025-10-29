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
          MyUserRepository,
          MyUserRepository,
          MyUserRepository
        >
    with $Provider<MyUserRepository> {
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
  $ProviderElement<MyUserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyUserRepository create(Ref ref) {
    return myUserRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyUserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyUserRepository>(value),
    );
  }
}

String _$myUserRepositoryHash() => r'd7647acb7660b1555a9741dce988b50122170093';
