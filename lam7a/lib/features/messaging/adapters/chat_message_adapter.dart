import 'package:hive/hive.dart';
import 'package:lam7a/core/hive_types.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = HiveTypes.chatMessage;

  @override
  ChatMessage read(BinaryReader reader) {
    return ChatMessage(
      conversationId: reader.read(),
      id: reader.read(),
      text: reader.read(),
      time: reader.read(),
      isMine: reader.read(),
      senderId: reader.read(),
      isSeen: reader.read(),
      isDelivered: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.write(obj.conversationId);
    writer.write(obj.id);
    writer.write(obj.text);
    writer.write(obj.time);
    writer.write(obj.isMine);
    writer.write(obj.senderId);
    writer.write(obj.isSeen);
    writer.write(obj.isDelivered);
  }
}
