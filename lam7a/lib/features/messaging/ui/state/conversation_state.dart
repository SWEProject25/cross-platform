import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_state.freezed.dart';

@freezed
abstract class ConversationState with _$ConversationState {
  const factory ConversationState({
    required Conversation conversation,
    @Default(false) bool isTyping,
  }) = _ConversationState;
}