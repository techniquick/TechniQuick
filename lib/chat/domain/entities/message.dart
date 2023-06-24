enum MessageType {
  text,
  image,
}

class Message {
  final String senderName;
  final String idFrom;
  final String idTo;
  final String content;
  final MessageType type;
  final bool isRead;
  final String timestamp;
  Message? replayMessage;
  Message({
    this.replayMessage,
    required this.senderName,
    required this.idFrom,
    required this.idTo,
    required this.content,
    required this.type,
    required this.isRead,
    required this.timestamp,
  });

  Message.fromJson(Map<String, dynamic> parsedJson)
      : idFrom = parsedJson['idFrom'] as String,
        replayMessage = parsedJson["replay_message"] == null
            ? null
            : Message.fromJson(parsedJson["replay_message"]),
        senderName = parsedJson['sender_name'] as String,
        idTo = parsedJson['idTo'] as String,
        content = parsedJson['content'] as String,
        type = MessageType.values[parsedJson['type'] as int],
        isRead = parsedJson['isRead'] ?? true,
        timestamp = parsedJson['timestamp'] as String;

  Map<String, dynamic> toMap() {
    return {
      'idFrom': idFrom,
      'sender_name': senderName,
      'idTo': idTo,
      'content': content,
      'type': type.index,
      'isRead': isRead,
      'timestamp': timestamp,
      'replay_message': replayMessage != null ? replayMessage!.toMap() : null,
    };
  }
}
