import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'dart:math' as math;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/util/navigator.dart';

import '../../../../core/util/toast.dart';
import '../../../../injection.dart';
import '../../../../model/categories.dart';
import '../../../../model/supplies.dart';
import '../../auth/nav_bar/bottom_nav_bar_cubit.dart';

part 'add_supplies_state.dart';

class ControlSuppliesCubit extends Cubit<ControlSuppliesState> {
  ControlSuppliesCubit() : super(ControlSuppliesInitial());

  get discription => null;

  String generateRandomString() {
    final random = math.Random.secure();
    var values = List<int>.generate(9, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<void> fAddSupplies({
    required String name,
    required String? suppliesCategory,
    required File? imageFile,
    required String price,
    required String discription,
  }) async {
    try {
      emit(ControlSuppliesLoading());
      final byteData = await imageFile!.readAsBytes();
      Uint8List imageData = byteData.buffer.asUint8List();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final task =
          await sl<FirebaseStorage>().ref().child(fileName).putData(imageData);
      final taskSnapshot = task;
      final image = await taskSnapshot.ref.getDownloadURL();
      final user = sl<FirebaseAuth>().currentUser!;
      final userData =
          await sl<FirebaseFirestore>().doc('users/${user.uid}').get();
      final list = (userData.data()?['supplies'] ?? []);
      final supplies = Supplies(
        name: name,
        rate: 0.0,
        suppliesCategory: SuppliesCategory(suppliesName: suppliesCategory!),
        image: image,
        price: price,
        discription: discription,
        id: generateRandomString(),
        userId: user.uid,
      );
      list.add(supplies.tojson());
      await FirebaseFirestore.instance
          .doc('users/${user.uid}')
          .update({'supplies': list});
      showToast('Supplies added successfully');
      sl<BottomBarCubit>().changeBottomBar(0);
      emit(ControlSuppliesSuccess());
    } catch (error) {
      log(error.toString());
      showToast(error.toString(), bg: Colors.red);
      emit(ControlSuppliesInitial());
    }
  }

  Future<void> fDeleteSupplies({required String id}) async {
    final user = sl<FirebaseAuth>().currentUser!;
    final userData =
        await sl<FirebaseFirestore>().doc('users/${user.uid}').get();
    final List list = (userData.data()?['supplies'] ?? []);
    list.removeWhere((element) => element["id"] == id);
    await FirebaseFirestore.instance
        .doc('users/${user.uid}')
        .update({'supplies': list});
    showToast('Supplies deleted successfully');
    sl<AppNavigator>().pop();
    emit(ControlSuppliesSuccess());
  }
}
