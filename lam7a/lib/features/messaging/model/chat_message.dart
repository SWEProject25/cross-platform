class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMine;

  ChatMessage({required this.text, required this.time, required this.isMine});
}