// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_view_page_view_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatViewPageViewModel)
const chatViewPageViewModelProvider = ChatViewPageViewModelProvider._();

final class ChatViewPageViewModelProvider
    extends $NotifierProvider<ChatViewPageViewModel, ChatPageState> {
  const ChatViewPageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatViewPageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatViewPageViewModelHash();

  @$internal
  @override
  ChatViewPageViewModel create() => ChatViewPageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPageState>(value),
    );
  }
}

String _$chatViewPageViewModelHash() =>
    r'fa6d2776970c06a80f07995aa349d31dca1e82d2';

abstract class _$ChatViewPageViewModel extends $Notifier<ChatPageState> {
  ChatPageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatPageState, ChatPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatPageState, ChatPageState>,
              ChatPageState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
