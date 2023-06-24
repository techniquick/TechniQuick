import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:techni_quick/firebase/firebase_routes.dart';

import '../../injection.dart';
import '../../model/user.dart';

User? currentFirebaseUser() => FirebaseAuth.instance.currentUser;

Stream<BaseUser> getUserData(String uid) => sl<FirebaseFirestore>()
    .doc(FirebaseRoute.userRoute(uid))
    .snapshots()
    .map((event) => userFromJson(event.data()!));

void updateFcm(String uid) async {
  final token = await FirebaseMessaging.instance.getToken();
  sl<FirebaseFirestore>()
      .doc(FirebaseRoute.userRoute(uid))
      .update({"fcm_token": token});
}
