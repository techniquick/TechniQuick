import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/util/app_location.dart';
import '../../../core/util/extintions.dart';
import '../../../core/util/navigator.dart';
import '../../../core/util/toast.dart';
import '../../../firebase/fcm_remote_datasource.dart';
import '../../../injection.dart';
import '../../../model/cart_order.dart';
import '../../../model/portfolio.dart';
import '../../../model/tech_order.dart';
import '../../../model/user.dart';
import '../../pages/client/wating_offers_screen.dart';
import '../../pages/technican/offer_sent.dart';
import '../auth/nav_bar/bottom_nav_bar_cubit.dart';

String orderPath() => 'tech_orders';
String orderPathWithId(String orderId) => 'tech_orders/$orderId';
String orderOffers(String orderId) => 'tech_orders/$orderId/offers';
String offerpath(String orderId, String offerid) =>
    'tech_orders/$orderId/offers/$offerid';
Position? lastLocation;

class TechOrderController {
  static Stream<List<Offer>> getOffers({required String orderId}) {
    return sl<FirebaseFirestore>()
        .collection(orderOffers(orderId))
        .where('offer_status', isEqualTo: 'newOffer')
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Offer.fromMap(e.data())).toList());
  }

  static Future<void> requestTech({
    required String details,
    required File? image,
    required String userUid,
    required String categoryName,
    required Client client,
  }) async {
    try {
      String? imageUrl = await uploadeImage(image);
      if (userUid.isNotEmpty) {
        final position = await sl<AppLocation>().determinePosition();
        String address = "لا يوجد عنوان";
        if (position != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            address =
                '${placemarks.first.street}, ${placemarks.first.postalCode} ${placemarks.first.locality}';
          }

          final TechRequest techRequest = TechRequest(
            id: "",
            categoryName: categoryName,
            problemDetails: details,
            addressCord: position.latLngFromPostion(),
            endUser: client,
            image: imageUrl,
            endUserId: client.id,
            address: address,
            createdAt: DateTime.now(),
            finalPrice: 0,
            status: OrderStatus.newOrder,
          );
          final order = await sl<FirebaseFirestore>()
              .collection(orderPath())
              .add(techRequest.toMap());
          sl<AppNavigator>().popToFrist();
          sl<AppNavigator>().push(
              screen: TechOffersScreen(
                  techRequest: techRequest, orderId: order.id));
        }

        showToast(tr("tech_added_successfully"));
      }
    } catch (e) {
      showToast(e.toString(), bg: Colors.red);
    }
  }

  static const double radius = 30000;
  static double calcDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371000; // Earth's radius in meters
    double phi1 = lat1 * math.pi / 180;
    double phi2 = lat2 * math.pi / 180;
    double deltaPhi = (lat2 - lat1) * math.pi / 180;
    double deltaLambda = (lng2 - lng1) * math.pi / 180;
    double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = R * c;
    return d;
  }

  static Stream<List<TechRequest>> getNewTechRequest() {
    final user = (sl<BottomBarCubit>().user as Technician);
    lastLocation = sl<AppLocation>().lastLocation;
    if (lastLocation == null) {
      return sl<FirebaseFirestore>()
          .collection(orderPath())
          .where("category_name", isEqualTo: user.techCategory.categoryName)
          .where("status", isEqualTo: "newOrder")
          .snapshots()
          .map((event) => event.docs
              .map((e) => TechRequest.fromMap(e.data())..id = e.id)
              .toList());
    }
    return sl<FirebaseFirestore>()
        .collection(orderPath())
        .where("category_name", isEqualTo: user.techCategory.categoryName)
        .where("status", isEqualTo: "newOrder")
        .snapshots()
        .map((event) => event.docs
                .map((e) => TechRequest.fromMap(e.data())..id = e.id)
                .toList()
                .where((item) {
              double distanceInMeters = calcDistance(lastLocation!.latitude,
                  lastLocation!.longitude, item.getLat(), item.getLng());

              return distanceInMeters <= radius;
            }).toList());
  }

  static Future<void> acceptOrder({
    required Client client,
    required String orderId,
    required Technician technician,
    required String priceMin,
    required String priceMax,
  }) async {
    final ref =
        await sl<FirebaseFirestore>().doc("users/${technician.id}").get();
    final userData = userFromJson(ref.data()!) as Technician;
    final offer = Offer(
      offerStatus: OfferStatus.newOffer,
      technician: userData,
      technicianId: technician.id,
      priceMax: priceMax,
      priceMin: priceMin,
    );
    await FCMRemoteDataSource.sendFCM(
      toFCM: client.fcmToken,
      title: 'New offer',
      body: 'new offer from ${technician.name}',
      reciverId: client.id,
    );
    sl<FirebaseFirestore>()
        .doc(offerpath(orderId, technician.id))
        .set(offer.toMap());
    sl<AppNavigator>().popToFrist();
    sl<AppNavigator>().push(screen: const OfferSentScreen());
  }

  static Future<void> finishOrder({
    required Technician technician,
    required Client client,
    required String orderId,
    required String finalPrice,
    required TechRequest techRequest,
    required File? image,
  }) async {
    String? imageUrl = await uploadeImage(image);
    techRequest.currentOffer!.image = imageUrl;
    techRequest.status = OrderStatus.finished;
    techRequest.currentOffer!.finalPrice = finalPrice;
    sl<FirebaseFirestore>()
        .doc(orderPathWithId(orderId))
        .update(techRequest.toMap());
    if (imageUrl != null) {
      final Portfolio portfolio = Portfolio(
          image: imageUrl,
          userName: techRequest.endUser.name,
          orderDescription: techRequest.problemDetails);
      final user = (sl<BottomBarCubit>().user as Technician);
      user.portfolios.add(portfolio);
      sl<FirebaseFirestore>().doc('users/${user.id}').update(user.toMap());
    }
    await FCMRemoteDataSource.sendFCM(
      toFCM: client.fcmToken,
      title: 'Your order Finished',
      body: 'your order has been Finished from ${technician.name}',
      reciverId: client.id,
    );
    showToast(tr("order_finished"));
    sl<AppNavigator>().pop();
  }

  static Future<void> rejectOffer({
    required Technician technician,
    required Client client,
    required String orderId,
    required String offerId,
  }) async {
    sl<FirebaseFirestore>()
        .doc(offerpath(orderId, offerId))
        .update({"offer_status": OfferStatus.rejected.name});
    await FCMRemoteDataSource.sendFCM(
      toFCM: technician.fcmToken,
      title: 'Your offer Accepted',
      body: 'your offer has been rejected from ${client.name}',
      reciverId: technician.id,
    );
    sl<AppNavigator>().pop();
  }

  static Future<void> cancelOrder({
    required String orderId,
    required String offerId,
  }) async {
    sl<FirebaseFirestore>()
        .doc(orderPathWithId(orderId))
        .update({"status": OrderStatus.canceled.name});
  }

  static Future<void> acceptOffer({
    required Technician technician,
    required Client client,
    required String orderId,
    required String offerId,
    required Offer offer,
  }) async {
    sl<FirebaseFirestore>()
        .doc(offerpath(orderId, offerId))
        .update({"offer_status": OfferStatus.accepted.name});
    sl<FirebaseFirestore>().doc(orderPathWithId(orderId)).update({
      "current_offer": offer.toMap()
        ..update('offer_status', (value) => OfferStatus.accepted.name),
      "status": OrderStatus.processing.name
    });
    await FCMRemoteDataSource.sendFCM(
      toFCM: technician.fcmToken,
      title: 'Your offer Accepted',
      body: 'your offer has been accepted from ${client.name}',
      reciverId: technician.id,
    );
    sl<AppNavigator>().pop();
    sl<AppNavigator>().pop();
  }

  static Future<String?> uploadeImage(File? image) async {
    if (image == null) {
      return null;
    }
    final byteData = await image.readAsBytes();
    Uint8List imageData = byteData.buffer.asUint8List();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final task =
        await sl<FirebaseStorage>().ref().child(fileName).putData(imageData);
    final taskSnapshot = task;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
