import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';

class ChatMessage {
  final int? conversationId;
  final int id;
  final String text;
  final DateTime time;
  final bool isMine;

  ChatMessage({this.conversationId, required this.id, required this.text, required this.time, required this.isMine});

  factory ChatMessage.fromDto(MessageDto dto, {required int currentUserId}) {
      return ChatMessage(
        conversationId: dto.conversationId,
        id: dto.id ?? 0,
        text: dto.text ?? '',
        time: dto.createdAt ?? DateTime.now(),
        isMine: dto.senderId == currentUserId,
      );
  }
}