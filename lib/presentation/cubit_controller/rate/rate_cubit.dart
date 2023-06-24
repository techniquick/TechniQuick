import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/core/util/toast.dart';
import 'package:techni_quick/firebase/firebase_routes.dart';
import 'package:techni_quick/model/cart_order.dart';

import '../../../injection.dart';
import '../../../model/user.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateInitial());

  Future<void> fRate(
      {required int rateNumber,
      required String comment,
      required String userUid,
      required BaseUser techOrSup,
      required String orderId}) async {
    emit(RateLoading());
    try {
      List<Rate> rates = [];
      if (techOrSup is Supplier) {
        rates = techOrSup.rates;
        sl<FirebaseFirestore>()
            .doc('cart_orders/$orderId')
            .update({"is_rate": true});
      } else if (techOrSup is Technician) {
        sl<FirebaseFirestore>()
            .doc('tech_orders/$orderId')
            .update({"is_rate": true});
        rates = techOrSup.rates;
      }
      final rate = Rate(rate: rateNumber, comment: comment);
      rates.add(rate);
      sl<FirebaseFirestore>().doc(FirebaseRoute.userRoute(userUid)).update({
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      });
      sl<AppNavigator>().pop();
      showToast(tr("rate_success"));
      emit(RateSuccess());
    } catch (e) {
      log(e.toString());

      emit(RateError(message: e.toString()));
    }
  }
}
