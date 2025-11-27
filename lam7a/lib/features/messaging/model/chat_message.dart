import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    int? conversationId,
    required int id,
    required String text,
    required DateTime time,
    required bool isMine,
    required int senderId,
    @Default(false) bool isSeen,
    @Default(true) bool isDelivered,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.fromDto(MessageDto dto, {required int currentUserId}) {
    return ChatMessage(
      conversationId: dto.conversationId,
      id: dto.id ?? 0,
      text: dto.text ?? '(Missing Message)',
      time: dto.createdAt ?? DateTime.now(),
      isMine: dto.senderId == currentUserId,
      senderId: dto.senderId ?? 0,
      isSeen: dto.isSeen ?? false,
    );
  }
}
