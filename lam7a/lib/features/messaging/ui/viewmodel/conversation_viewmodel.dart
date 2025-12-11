import 'dart:async';

import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/providers/unread_conversations_count.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/ui/state/conversation_state.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class ConversationViewmodel extends _$ConversationViewmodel {
  final Logger _logger = getLogger(ConversationViewmodel);

  late int _conversationId;

  StreamSubscription<bool>? _typingSubscription;
  StreamSubscription<MessageDto>? _newMessageSub;
  StreamSubscription<MessageDto>? _newMessageNotificationsSub;

  Timer? _typingTimer;

  @override
  ConversationState build(int conversationId) {
    _logger.i("Building ConversationViewmodel for conversationId: $conversationId");
    _conversationId = conversationId;

    var messagesRepository = ref.read(messagesRepositoryProvider);
    var messagesSocket = ref.read(messagesSocketServiceProvider);

    try {
      _typingSubscription = messagesRepository
          .onUserTyping(conversationId)
          .listen(
            (isTyping) => _onUserTypingChanged(conversationId, isTyping),
            onError: (error) => _logger.e(
              "Typing stream error for conversation $conversationId: $error",
            ),
          );

      _newMessageSub = messagesSocket.incomingMessages.listen(_onNewMessagesArrive);
      _newMessageNotificationsSub = messagesSocket.incomingMessagesNotifications.listen(_onNewMessagesArrive);
    } catch (e) {
      _logger.e(
        "Error subscribing to typing events for conversation $conversationId: $e",
      );
    }
    ref.onDispose(() {
      _logger.i("Disposing ConversationViewmodel for conversationId: $conversationId");
      _typingSubscription?.cancel();
      _typingTimer?.cancel();

      _newMessageSub?.cancel();
      _newMessageNotificationsSub?.cancel();
    });
    return ConversationState();
  }

  void _onNewMessagesArrive(MessageDto message) {
    if(message.conversationId != _conversationId) return;

    state = state.copyWith(
      lastMessage: message.text ?? state.lastMessage,
      lastMessageTime: message.createdAt ?? state.lastMessageTime,
      unseenCount: message.unseenCount ?? state.unseenCount,
    );
  }

  void _onUserTypingChanged(int convId, bool isTyping) {
    if(state.conversation?.isBlocked ?? false) return;

    state = state.copyWith(isTyping: isTyping);

    if (isTyping) {
      if (_typingTimer?.isActive ?? false) {
        _typingTimer!.cancel();
        _typingTimer = null;
      }

      _typingTimer = Timer(const Duration(seconds: 3), () {
        _onUserTypingChanged(convId, false);
      });
    } else {
      _typingTimer?.cancel();
      _typingTimer = null;
    }
  }

  void setConversation(Conversation newConversation) {
    state = state.copyWith(conversation: newConversation);
  }

  void markConversationAsSeen() {
    ref.read(messagesRepositoryProvider).sendMarkAsSeen(_conversationId);
    ref.read(unReadConversationsCountProvider.notifier).refresh();
    state = state.copyWith(unseenCount: 0);
  }

  void setConversationBlocked(bool isBlocked) {
    var updatedConversation = state.conversation?.copyWith(isBlocked: isBlocked);
    if (updatedConversation != null) {
      state = state.copyWith(conversation: updatedConversation);
    }
  }
}
