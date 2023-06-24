import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techni_quick/core/util/styles.dart';

import '../../core/constant.dart';
import '../../injection.dart';
import '../../model/notifications_model.dart';
import '../widgets/home_card.dart';
import '../widgets/notification_card.dart';

User? currentFirebaseUser() => sl<FirebaseAuth>().currentUser;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
          title: Text(
        tr("notifications"),
        style: TextStyles.bodyText18.copyWith(color: white),
      )),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentFirebaseUser()!.uid)
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error Occured !'));
            }
            final List<NotificationModel> notificationList = snapshot.data!.docs
                .map((doc) => NotificationModel.fromMap(
                    doc.data() as Map<String, dynamic>))
                .toList();

            return notificationList.isEmpty
                ? Center(
                    child: Text(tr('no_notifications_list'),
                        style: TextStyles.bodyText18.copyWith(color: white)))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: notificationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: FrostedGlassBox(
                              borderRasius: 10.r,
                              theHeight: 160.h,
                              theChild: NotificationCard(
                                  time:
                                      "${notificationList[index].createdAt.year}/${notificationList[index].createdAt.month}/${notificationList[index].createdAt.day}",
                                  body: notificationList[index].body,
                                  title: notificationList[index].title),
                            ),
                          ).animate()
                            ..slideX(
                                    delay: ((index * 80) > 240
                                            ? 240
                                            : (index * 80))
                                        .ms)
                                .shimmer(color: darkerColor);
                        }),
                  );
          }),
    );
  }
}
