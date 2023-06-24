import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techni_quick/presentation/cubit_controller/cart/cart.dart';

import '../../injection.dart';
import '../../model/Supplies.dart';

class CartItemWidget extends StatelessWidget {
  final CartSupplies cartSupplies;

  const CartItemWidget({
    super.key,
    required this.cartSupplies,
  });

  @override
  Widget build(BuildContext context) {
    final userId = sl<FirebaseAuth>().currentUser!.uid;
    return Card(
      child: ListTile(
        leading: Image.network(
          cartSupplies.image,
          width: 75,
          fit: BoxFit.cover,
        ),
        title: Text(
          cartSupplies.name,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        subtitle: Row(
          children: [
            Text(
              tr(cartSupplies.suppliesCategory.suppliesName),
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
                " - ${int.parse(cartSupplies.price) * cartSupplies.quantity} ${tr("EGP")}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                )),
          ],
        ),
        trailing: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => CartController.addTocart(
                      fromCart: true, supplies: cartSupplies, userUid: userId),
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                  ),
                ),
                Text(
                  cartSupplies.quantity.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                IconButton(
                  onPressed: () => CartController.deleteOneFromCart(
                      supplies: cartSupplies, userUid: userId),
                  icon: const Icon(
                    Icons.remove,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
