import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_state.freezed.dart';

@freezed
abstract class ConversationState with _$ConversationState {
  const factory ConversationState({
    @Default(false) bool isTyping,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unseenCount,
    Conversation? conversation,
  }) = _ConversationState;
}