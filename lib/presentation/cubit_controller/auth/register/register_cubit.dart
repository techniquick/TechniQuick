import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/util/app_location.dart';
import 'package:techni_quick/core/util/extintions.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/core/util/toast.dart';
import 'package:techni_quick/model/categories.dart';
import 'package:techni_quick/model/user.dart';

import '../../../../firebase/firebase_routes.dart';
import '../../../../injection.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> fRegister({
    required File imageFile,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType type,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      try {
        emit(RegisterLoading());
        UserCredential userCredential = await sl<FirebaseAuth>()
            .createUserWithEmailAndPassword(email: email, password: password);
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageUrl = await (await sl<FirebaseStorage>()
                .ref()
                .child(fileName)
                .putData(await imageFile.readAsBytes()))
            .ref
            .getDownloadURL();

        final location = await sl<AppLocation>().determinePosition();
        if (location == null) {
          emit(RegisterInitial());
          showToast("يرجي السماح بالموقع");
          return;
        }
        if (userCredential.user != null) {
          late BaseUser baseUser;
          if (type == UserType.supplier) {
            baseUser = Supplier(
              isVerfied: false,
              rates: [],
              fcmToken: await FirebaseMessaging.instance.getToken() ?? "",
              image: imageUrl,
              supplies: [],
              id: userCredential.user!.uid,
              type: type,
              addressCord: location.latLngFromPostion(),
              name: name,
              email: email,
              phone: phone,
            );
          } else if (type == UserType.client) {
            baseUser = Client(
              isVerfied: false,
              fcmToken: await FirebaseMessaging.instance.getToken() ?? "",
              image: imageUrl,
              id: userCredential.user!.uid,
              type: type,
              addressCord: location.latLngFromPostion(),
              name: name,
              email: email,
              phone: phone,
            );
          }

          await FirebaseFirestore.instance
              .doc(FirebaseRoute.userRoute(userCredential.user!.uid))
              .set(baseUser.toMap());

          await userCredential.user!.sendEmailVerification();
          sl<AppNavigator>().popToFrist();
        }
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        showToast(e.message);
        emit(RegisterError(
            message: e.message ?? "An error Occured ,please try again later"));
      }
    }
  }

  Future<void> fRegisterTech({
    required File imageFile,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType type,
    required String nationalId,
    required TechCategory techCategory,
  }) async {
    try {
      emit(RegisterLoading());
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageUrl = await (await sl<FirebaseStorage>()
              .ref()
              .child(fileName)
              .putData(await imageFile.readAsBytes()))
          .ref
          .getDownloadURL();
      final location = await sl<AppLocation>().determinePosition();
      if (location == null) {
        emit(RegisterInitial());
        showToast("يرجي السماح بالموقع");
        return;
      }
      if (userCredential.user != null) {
        final baseUser = Technician(
          isVerfied: false,
          isOnline: false,
          rates: [],
          portfolios: [],
          nationalId: nationalId,
          techCategory: techCategory,
          fcmToken: await FirebaseMessaging.instance.getToken() ?? "",
          image: imageUrl,
          id: userCredential.user!.uid,
          type: type,
          addressCord: location.latLngFromPostion(),
          name: name,
          email: email,
          phone: phone,
        );
        await FirebaseFirestore.instance
            .doc(FirebaseRoute.userRoute(userCredential.user!.uid))
            .set(baseUser.toMap());
        await userCredential.user!.sendEmailVerification();
        sl<AppNavigator>().popToFrist();
      }
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      showToast(e.message);
      emit(RegisterError(
          message: e.message ?? "An error Occured ,please try again later"));
    }
  }
}
