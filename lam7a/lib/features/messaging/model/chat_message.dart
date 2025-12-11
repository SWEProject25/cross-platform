import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:hive/hive.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @HiveField(0) int? conversationId,
    @HiveField(1) required int id,
    @HiveField(2) required String text,
    @HiveField(3) required DateTime time,
    @HiveField(4) required bool isMine,
    @HiveField(5) required int senderId,
    @HiveField(6) @Default(false) bool isSeen,
    @HiveField(7) @Default(true) bool isDelivered,
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