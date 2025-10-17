// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dm_list_page_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DMListPageViewModel)
const dMListPageViewModelProvider = DMListPageViewModelProvider._();

final class DMListPageViewModelProvider
    extends $NotifierProvider<DMListPageViewModel, DMListState> {
  const DMListPageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dMListPageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dMListPageViewModelHash();

  @$internal
  @override
  DMListPageViewModel create() => DMListPageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DMListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DMListState>(value),
    );
  }
}

String _$dMListPageViewModelHash() =>
    r'425d1b85ab3ec6e7a06dd74b9d72c8d0245333f5';

abstract class _$DMListPageViewModel extends $Notifier<DMListState> {
  DMListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DMListState, DMListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DMListState, DMListState>,
              DMListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
