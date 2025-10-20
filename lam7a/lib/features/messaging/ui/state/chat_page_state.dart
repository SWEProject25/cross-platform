import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_page_state.freezed.dart';

@freezed
abstract class ChatPageState with _$ChatPageState {
  const factory ChatPageState({
    @Default(AsyncValue.loading()) AsyncValue<List<ChatMessage>> messages,
  }) = _ChatPageState;
}