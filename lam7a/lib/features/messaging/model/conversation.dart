import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    required String name,
    required int userId,
    required String username,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default(0) int unseenCount,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  factory Conversation.fromDto(ConversationDto x) {
    return Conversation(
        id: x.id,
        userId: x.user.id,
        name: x.user.displayName,
        username: x.user.username,
        avatarUrl: x.user.profileImageUrl,
        lastMessage: x.lastMessage?.text,
        lastMessageTime: x.updatedAt,
        unseenCount: x.unseenCount,
      );
  }
}
