// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_tweet_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddTweetViewmodel)
const addTweetViewmodelProvider = AddTweetViewmodelProvider._();

final class AddTweetViewmodelProvider
    extends $NotifierProvider<AddTweetViewmodel, AddTweetState> {
  const AddTweetViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addTweetViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addTweetViewmodelHash();

  @$internal
  @override
  AddTweetViewmodel create() => AddTweetViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddTweetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddTweetState>(value),
    );
  }
}

String _$addTweetViewmodelHash() => r'580e9eb371d7b5a4ee5f0b4e558aa5b51698919e';

abstract class _$AddTweetViewmodel extends $Notifier<AddTweetState> {
  AddTweetState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AddTweetState, AddTweetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddTweetState, AddTweetState>,
              AddTweetState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
