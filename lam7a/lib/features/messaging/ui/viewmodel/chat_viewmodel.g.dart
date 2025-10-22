// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatViewModel)
const chatViewModelProvider = ChatViewModelFamily._();

final class ChatViewModelProvider
    extends $NotifierProvider<ChatViewModel, ChatState> {
  const ChatViewModelProvider._({
    required ChatViewModelFamily super.from,
    required (String, Contact?) super.argument,
  }) : super(
         retry: null,
         name: r'chatViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatViewModelHash();

  @override
  String toString() {
    return r'chatViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ChatViewModel create() => ChatViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatViewModelHash() => r'e9dad278102b1b406b10e6f51e6566866150b402';

final class ChatViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatViewModel,
          ChatState,
          ChatState,
          ChatState,
          (String, Contact?)
        > {
  const ChatViewModelFamily._()
    : super(
        retry: null,
        name: r'chatViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatViewModelProvider call(String userId, [Contact? user]) =>
      ChatViewModelProvider._(argument: (userId, user), from: this);

  @override
  String toString() => r'chatViewModelProvider';
}

abstract class _$ChatViewModel extends $Notifier<ChatState> {
  late final _$args = ref.$arg as (String, Contact?);
  String get userId => _$args.$1;
  Contact? get user => _$args.$2;

  ChatState build(String userId, [Contact? user]);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
