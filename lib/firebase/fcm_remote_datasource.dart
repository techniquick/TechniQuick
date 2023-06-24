import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../core/error/exceptions.dart';

const serverKey =
    "AAAAND6D690:APA91bFgfTWfeCO5QWAjh_99DbsqnuQyY5ohk7Ry_YeMABkZhWZSMXb6lIfL7a_nrq5KWgrZGApUoEUqGXA4c80IoBZ1YKD2J5K1DuaBSOhQseuNf1-LnwnV0swry04rd-_097Tm6rdj";

class FCMRemoteDataSource {
  static Future<void> sendFCM({
    required String toFCM,
    required String title,
    required String body,
    required String reciverId,
  }) async {
    try {
      await Dio().post('https://fcm.googleapis.com/fcm/send',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'key=$serverKey'
            },
          ),
          data: jsonEncode({
            'to': toFCM,
            'data': {"data": 'data'},
            "notification": {
              "title": title,
              "body": body,
            }
          }));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(reciverId)
          .collection('notifications')
          .doc()
          .set({
        "title": title,
        "body": body,
        'created_at': DateTime.now().toString(),
      });
    } catch (e) {
      throw ServerException(message: tr(""));
    }
  }
}
