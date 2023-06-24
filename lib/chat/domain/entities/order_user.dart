import 'dart:convert';

import 'package:techni_quick/model/user.dart';

class ChatUser {
  final String id;
  final String username;
  final String phone;
  final String? fcmToken;
  ChatUser({
    required this.fcmToken,
    required this.id,
    required this.phone,
    required this.username,
  });

  ChatUser copyWith(
      {String? id,
      String? image,
      String? username,
      String? email,
      String? phone,
      int? age,
      String? idLicence,
      String? idLicenceFace,
      String? idLicenceBack,
      String? longitude,
      String? latitude,
      String? address,
      String? fcmToken}) {
    return ChatUser(
      fcmToken: fcmToken ?? this.fcmToken,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fcm_token': fcmToken,
    };
  }

  factory ChatUser.fromAppUser(BaseUser user) => ChatUser(
        fcmToken: user.fcmToken,
        id: user.id,
        username: user.name,
        phone: user.phone,
      );
  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      fcmToken: map['fcm_token'],
      id: map['id'] ?? "0",
      phone: map['phone'] ?? "0",
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, username: $username,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatUser && other.id == id && other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode;
  }
}
