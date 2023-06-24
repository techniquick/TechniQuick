import 'package:flutter/material.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/presentation/pages/cart_screen.dart';

import '../../injection.dart';
import '../../model/user.dart';
import '../../presentation/cubit_controller/cart/cart.dart';
import '../constant.dart';

class CartAppBarIcon extends StatelessWidget {
  const CartAppBarIcon({
    super.key,
    required this.user,
  });

  final BaseUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<int>(
          stream: CartController.getCartCount(userUid: user.id),
          builder: (context, snapshot) {
            return InkWell(
              onTap: () {
                sl<AppNavigator>().push(screen: const CartScreen());
              },
              child: Badge.count(
                  count: snapshot.data ?? 0,
                  textColor: white,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.card_giftcard_outlined, color: darkerColor),
                  )),
            );
          }),
    );
  }
}
