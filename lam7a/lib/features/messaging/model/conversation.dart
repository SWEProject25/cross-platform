class Conversation {
  final int id;
  final String name;
  final String? avatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  Conversation({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    this.lastMessageTime,
  });
}
