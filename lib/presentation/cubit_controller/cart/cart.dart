import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/core/util/toast.dart';
import 'package:techni_quick/model/Supplies.dart';
import 'package:techni_quick/model/cart_order.dart';

import '../../../firebase/fcm_remote_datasource.dart';
import '../../../firebase/firebase_routes.dart';
import '../../../injection.dart';
import '../../../model/user.dart';
import '../auth/nav_bar/bottom_nav_bar_cubit.dart';

String cartItemsPath(String userId) => 'cart/$userId/items';
String cartPath(String userId) => 'cart/$userId';
String orderPath() => 'cart_orders';

class CartController {
  static Future<void> addTocart(
      {required Supplies supplies,
      bool fromCart = false,
      required String userUid}) async {
    try {
      if (userUid.isNotEmpty) {
        final doc = await sl<FirebaseFirestore>()
            .collection(cartItemsPath(userUid))
            .get();
        final index =
            doc.docs.indexWhere((element) => element["id"] == supplies.id);
        if (index == -1) {
          sl<FirebaseFirestore>()
              .collection(cartItemsPath(userUid))
              .add({...supplies.tojson(), 'quantity': 1});
        } else {
          sl<FirebaseFirestore>()
              .doc("${cartItemsPath(userUid)}/${doc.docs[index].id}")
              .update({
            ...supplies.tojson(),
            'quantity': doc.docs[index]['quantity'] + 1
          });
        }
      }
      if (!fromCart) {
        showToast(tr("item_added_to_cart_successfully"));
      }
    } catch (e) {
      showToast(e.toString(), bg: Colors.red);
    }
  }

  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return null;
    }
    final lastLocation = await Geolocator.getCurrentPosition();
    return lastLocation;
  }

  static Future<void> submitCartOrder(
      {required List<CartSupplies> supplies, required String userUid}) async {
    try {
      final position = await determinePosition();
      String address = "لا يوجد عنوان";
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          address =
              '${placemarks.first.street}, ${placemarks.first.postalCode} ${placemarks.first.locality}';
        }
      }
      final endUser = sl<BottomBarCubit>().user;
      if (userUid.isNotEmpty) {
        // this for making muilty order with the same cart
        Map<String, List<CartSupplies>> map = {};
        for (CartSupplies ob in supplies) {
          if (map.containsKey(ob.userId)) {
            map[ob.userId]!.add(ob);
          } else {
            map[ob.userId] = [ob];
          }
        }
        List<List<CartSupplies>> supliersData = [];
        map.forEach((key, value) {
          supliersData.add(value);
        });
        for (var i = 0; i < supliersData.length; i++) {
          final supllierUser = userFromJson((await sl<FirebaseFirestore>()
                  .doc(FirebaseRoute.userRoute(supliersData.first.first.userId))
                  .get())
              .data()!);

          final CartOrder cartOrder = CartOrder(
              address: address,
              cartSupplies: supliersData[i],
              supplierUserId: supliersData.first.first.userId,
              endUserId: endUser.id,
              endUser: endUser,
              supplierUser: supllierUser,
              createdAt: DateTime.now(),
              status: OrderStatus.newOrder);
          sl<FirebaseFirestore>()
              .collection(orderPath())
              .add(cartOrder.toMap());
          await FCMRemoteDataSource.sendFCM(
            toFCM: supllierUser.fcmToken,
            title: 'New Order',
            body: 'new order from ${endUser.name}',
            reciverId: supllierUser.id,
          );
        }
        await deleteCart(userUid: userUid);
      }
      showToast(tr("submit_cart_successfully"));
      sl<AppNavigator>().popToFrist();
      sl<BottomBarCubit>().changeBottomBar(2);
    } catch (e) {
      showToast(e.toString(), bg: Colors.red);
    }
  }

  static Future<void> deleteCart({required String userUid}) async {
    if (userUid.isNotEmpty) {
      final ref = await sl<FirebaseFirestore>()
          .collection('cart')
          .doc(userUid)
          .collection('items')
          .get();
      for (var element in ref.docs) {
        element.reference.delete();
      }
    }
  }

  static Future<void> deleteFromCart(
      {required Supplies supplies, required String userUid}) async {
    if (userUid.isNotEmpty) {
      final doc = await sl<FirebaseFirestore>()
          .collection(cartItemsPath(userUid))
          .get();
      final index =
          doc.docs.indexWhere((element) => element["id"] == supplies.id);
      if (index == -1) {
        return;
      } else {
        sl<FirebaseFirestore>()
            .doc("${cartItemsPath(userUid)}/${doc.docs[index].id}")
            .delete();
      }
      showToast(tr("item_removed_from_cart_successfully"));
    }
  }

  static Future<void> deleteOneFromCart(
      {required Supplies supplies, required String userUid}) async {
    if (userUid.isNotEmpty) {
      final doc = await sl<FirebaseFirestore>()
          .collection(cartItemsPath(userUid))
          .get();
      final index =
          doc.docs.indexWhere((element) => element["id"] == supplies.id);
      if (index == -1) {
        return;
      } else {
        if (doc.docs[index]['quantity'] == 1) {
          deleteFromCart(supplies: supplies, userUid: userUid);
        } else {
          sl<FirebaseFirestore>()
              .doc("${cartItemsPath(userUid)}/${doc.docs[index].id}")
              .update({
            ...supplies.tojson(),
            'quantity': doc.docs[index]['quantity'] - 1
          });
        }
      }
    }
  }

  static Stream<List<CartSupplies>> getCart({required String userUid}) {
    final col =
        sl<FirebaseFirestore>().collection(cartItemsPath(userUid)).snapshots();
    return col.map((event) =>
        event.docs.map((e) => CartSupplies.fromJson(e.data())).toList());
  }

  static Stream<int> getCartCount({required String userUid}) {
    final col =
        sl<FirebaseFirestore>().collection(cartItemsPath(userUid)).snapshots();
    return col.map((event) => event.docs.length);
  }
}
