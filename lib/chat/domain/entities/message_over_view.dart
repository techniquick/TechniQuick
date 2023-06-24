class MessageOverView {
  final String newMessagesCount;
  final String messageContent;
  final String messageTime;
  final bool fromMe;
  final bool newChat;
  MessageOverView(
      {required this.newMessagesCount,
      required this.newChat,
      required this.fromMe,
      required this.messageContent,
      required this.messageTime});
}
