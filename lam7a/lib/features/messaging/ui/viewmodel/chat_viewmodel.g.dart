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
    required ({String userId, Contact? user}) super.argument,
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

String _$chatViewModelHash() => r'8bddbc36371f61ad5c3c053cec196fc3ff64c8a6';

final class ChatViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatViewModel,
          ChatState,
          ChatState,
          ChatState,
          ({String userId, Contact? user})
        > {
  const ChatViewModelFamily._()
    : super(
        retry: null,
        name: r'chatViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatViewModelProvider call({required String userId, Contact? user}) =>
      ChatViewModelProvider._(
        argument: (userId: userId, user: user),
        from: this,
      );

  @override
  String toString() => r'chatViewModelProvider';
}

abstract class _$ChatViewModel extends $Notifier<ChatState> {
  late final _$args = ref.$arg as ({String userId, Contact? user});
  String get userId => _$args.userId;
  Contact? get user => _$args.user;

  ChatState build({required String userId, Contact? user});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(userId: _$args.userId, user: _$args.user);
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
