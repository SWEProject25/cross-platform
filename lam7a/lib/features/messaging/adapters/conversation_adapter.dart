import 'package:hive/hive.dart';
import 'package:lam7a/core/hive_types.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = HiveTypes.conversation;

  @override
  Conversation read(BinaryReader reader) {
    return Conversation(
      id: reader.read(),
      name: reader.read(),
      avatarUrl: reader.read(),
      isBlocked: reader.read(),
      userId: reader.read(),
      username: reader.read(),
      lastMessage: reader.read(),
      lastMessageTime: reader.read(),
      unseenCount: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
      writer.write(obj.id);
      writer.write(obj.name);
      writer.write(obj.avatarUrl);
      writer.write(obj.isBlocked);
      writer.write(obj.userId);
      writer.write(obj.username);
      writer.write(obj.lastMessage);
      writer.write(obj.lastMessageTime);
      writer.write(obj.unseenCount);
  }
}
