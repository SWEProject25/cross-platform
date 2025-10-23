import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversations_state.freezed.dart';

@freezed
abstract class ConversationsState with _$ConversationsState {
  const factory ConversationsState({
    @Default(AsyncValue.loading()) AsyncValue<List<Conversation>> conversations,
    @Default(AsyncValue.loading()) AsyncValue<List<Contact>> contacts,
  }) = _ConversationsState;
}