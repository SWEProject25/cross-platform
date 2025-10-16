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
    extends $AsyncNotifierProvider<DMListPageViewModel, List<Conversation>> {
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
}

String _$dMListPageViewModelHash() =>
    r'2ab07ab2368e35162c3f79da51fe0ca461fc74dc';

abstract class _$DMListPageViewModel
    extends $AsyncNotifier<List<Conversation>> {
  FutureOr<List<Conversation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Conversation>>, List<Conversation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Conversation>>, List<Conversation>>,
              AsyncValue<List<Conversation>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
