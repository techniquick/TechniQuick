import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';

import 'chat/injection_container.dart';
import 'core/util/app_location.dart';

final sl = GetIt.instance;
void init() {
  initChat(sl);
  sl.registerLazySingleton<BottomBarCubit>(() => BottomBarCubit());
  sl.registerLazySingleton<AppNavigator>(() => AppNavigator());
  sl.registerLazySingleton<AppLocation>(() => AppLocationImpl());
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
}
