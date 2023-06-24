class NotificationModel {
  String title;
  String body;
  DateTime createdAt;

  NotificationModel({
    required this.title,
    required this.body,
    required this.createdAt,
  });

  // Factory method to create a NotificationModel instance from a Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Method to convert a NotificationModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
