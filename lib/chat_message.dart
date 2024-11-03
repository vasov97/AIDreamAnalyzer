class ChatMessage {
  final String text;
  final bool isUser;
  final bool isButton;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isButton = false,
  });
}
