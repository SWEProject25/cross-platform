class ChatMessage {
  final int? conversationId;
  final int id;
  final String text;
  final DateTime time;
  final bool isMine;

  ChatMessage({this.conversationId, required this.id, required this.text, required this.time, required this.isMine});
}