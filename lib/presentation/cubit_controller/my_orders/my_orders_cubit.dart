import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import 'package:techni_quick/presentation/pages/my_orders.dart';

import '../../../firebase/fcm_remote_datasource.dart';
import '../../../injection.dart';
import '../../../model/cart_order.dart';
import '../../../model/tech_order.dart';
import '../../../model/user.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(MyOrdersInitial());
  OrderStatus selectedStatus = OrderStatus.newOrder;
  OrderType selectedType = OrderType.cart_orders;

  List<OrderType> listOrderType = [
    OrderType.cart_orders,
    OrderType.tech_orders,
  ];
  List<OrderStatus> listOrderStatus() {
    return sl<BottomBarCubit>().user.type == UserType.technician &&
            selectedType.name == OrderType.tech_orders.name
        ? [
            OrderStatus.processing,
            OrderStatus.finished,
            OrderStatus.canceled,
          ]
        : [
            OrderStatus.newOrder,
            OrderStatus.processing,
            OrderStatus.finished,
            OrderStatus.canceled,
          ];
  }

  ScrollController controllerType = ScrollController();
  ScrollController controller = ScrollController();

  changeSelectedType({required OrderType newStatus}) {
    emit(MyOrdersInitial());
    selectedType = newStatus;
    if (sl<BottomBarCubit>().user.type == UserType.technician &&
        newStatus.name == OrderType.tech_orders.name) {
      selectedStatus = OrderStatus.processing;
    } else {
      selectedStatus = OrderStatus.newOrder;
    }
    controllerType.animateTo(
        (controller.position.maxScrollExtent / 2) *
            listOrderStatus().indexOf(selectedStatus),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic);
    emit(MyOrdersChange());
  }

  changeSelectedStatus({required OrderStatus newStatus}) {
    emit(MyOrdersInitial());
    selectedStatus = newStatus;
    controller.animateTo(
        (controller.position.maxScrollExtent / 2) *
            listOrderStatus().indexOf(selectedStatus),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic);
    emit(MyOrdersChange());
  }

  initSelectedStatus({required OrderStatus newStatus}) {
    emit(MyOrdersInitial());
    selectedStatus = newStatus;
    emit(MyOrdersChange());
  }

  changeToCancelled() {
    emit(MyOrdersInitial());
    selectedStatus = OrderStatus.canceled;
    controller.jumpTo(controller.position.maxScrollExtent);
    emit(MyOrdersChange());
  }

  Stream<List<BaseOrder>> fGetCartOrders({required UserType type}) {
    if (selectedType == OrderType.cart_orders) {
      if (type == UserType.supplier) {
        return sl<FirebaseFirestore>()
            .collection(selectedType.name)
            .where('supplier_user_id',
                isEqualTo: sl<FirebaseAuth>().currentUser!.uid)
            .where("status", isEqualTo: selectedStatus.name)
            .snapshots()
            .map((event) => event.docs
                .map((e) => CartOrder.fromMap(e.data())..id = e.id)
                .toList());
      } else {
        return sl<FirebaseFirestore>()
            .collection(selectedType.name)
            .where('end_user_id',
                isEqualTo: sl<FirebaseAuth>().currentUser!.uid)
            .where("status", isEqualTo: selectedStatus.name)
            .snapshots()
            .map((event) => event.docs
                .map((e) => CartOrder.fromMap(e.data())..id = e.id)
                .toList());
      }
    } else {
      if (type == UserType.client) {
        return sl<FirebaseFirestore>()
            .collection(selectedType.name)
            .where('end_user_id',
                isEqualTo: sl<FirebaseAuth>().currentUser!.uid)
            .where("status", isEqualTo: selectedStatus.name)
            .snapshots()
            .map((event) => event.docs
                .map((e) => TechRequest.fromMap(e.data())..id = e.id)
                .toList());
      } else {
        return sl<FirebaseFirestore>()
            .collection(selectedType.name)
            .where('current_offer.technician_id',
                isEqualTo: sl<FirebaseAuth>().currentUser!.uid)
            .where("status", isEqualTo: selectedStatus.name)
            .snapshots()
            .map((event) => event.docs
                .map((e) => TechRequest.fromMap(e.data())..id = e.id)
                .toList());
      }
    }
  }

  Future<void> cancelOrder(
      {required String orderId,
      BaseUser? supplier,
      required BaseUser enduser}) async {
    sl<FirebaseFirestore>()
        .doc("${selectedType.name}/$orderId")
        .update({"status": OrderStatus.canceled.name});
    if (supplier != null) {
      await FCMRemoteDataSource.sendFCM(
        toFCM: supplier.fcmToken,
        title: 'Order is canceled',
        body: '${enduser.name} canceld his new order',
        reciverId: supplier.id,
      );
    }
  }

  Future<void> supplierChangeOrderStatus(
      {required String docId,
      required OrderStatus newOrderStatus,
      required Supplier supplier,
      required BaseUser enduser}) async {
    sl<FirebaseFirestore>()
        .doc("${selectedType.name}/$docId")
        .update({"status": newOrderStatus.name});
    await FCMRemoteDataSource.sendFCM(
      toFCM: enduser.fcmToken,
      title: 'Order is ${newOrderStatus.name}',
      body: 'your supplies order is now ${newOrderStatus.name}',
      reciverId: enduser.id,
    );
  }
}
