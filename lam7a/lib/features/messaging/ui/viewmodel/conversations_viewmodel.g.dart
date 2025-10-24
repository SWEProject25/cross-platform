// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConversationsViewModel)
const conversationsViewModelProvider = ConversationsViewModelProvider._();

final class ConversationsViewModelProvider
    extends $NotifierProvider<ConversationsViewModel, ConversationsState> {
  const ConversationsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsViewModelHash();

  @$internal
  @override
  ConversationsViewModel create() => ConversationsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationsState>(value),
    );
  }
}

String _$conversationsViewModelHash() =>
    r'bdca52e46196f5a1b1c472572f66648656a61fbf';

abstract class _$ConversationsViewModel extends $Notifier<ConversationsState> {
  ConversationsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ConversationsState, ConversationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversationsState, ConversationsState>,
              ConversationsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
