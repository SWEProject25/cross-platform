import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    required String name,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
