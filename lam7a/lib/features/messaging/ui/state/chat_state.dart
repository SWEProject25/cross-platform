import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    // @Default(-1) int conversationId,
    @Default(AsyncValue.loading()) AsyncValue<Contact> contact,
    @Default(AsyncValue.loading()) AsyncValue<List<ChatMessage>> messages,
    @Default(true) bool hasMoreMessages,
    @Default(false) bool loadingMoreMessages,
    @Default(false) bool isTyping,
    @Default("") String draftMessage,

    @Default(AsyncValue.loading()) AsyncValue<Conversation> conversation,
    // @Default(false) bool isBlocked,
  }) = _ChatState;
}