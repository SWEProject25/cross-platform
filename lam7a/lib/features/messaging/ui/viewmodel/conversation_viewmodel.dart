import 'dart:async';

import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/providers/conversations_provider.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/conversation_state.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_viewmodel.g.dart';

@riverpod
class ConversationViewmodel extends _$ConversationViewmodel {
  final Logger _logger = getLogger(ConversationViewmodel);
  late MessagesRepository _messagesRepository;
  StreamSubscription<bool>? _typingSubscription;
  @override
  ConversationState build(int conversationId) {
    _messagesRepository = ref.read(messagesRepositoryProvider);

    var conversations = ref.watch(conversationsProvider);

    var conversation = conversations.items.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => throw Exception("Conversation not found"),
    );

    try {
      _typingSubscription = _messagesRepository
          .onUserTyping(conversationId)
          .listen(
            (isTyping) => _onUserTypingChanged(conversationId, isTyping),
            onError: (error) => _logger.e(
              "Typing stream error for conversation $conversationId: $error",
            ),
          );
    } catch (e) {
      _logger.e(
        "Error subscribing to typing events for conversation $conversationId: $e",
      );
    }
    ref.onDispose(() {
      _typingSubscription?.cancel();
    });
    return ConversationState(conversation: conversation);
  }

  void _onUserTypingChanged(int convId, bool isTyping) {
    state = state.copyWith(isTyping: isTyping);
  }
}
