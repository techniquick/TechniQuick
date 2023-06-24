import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/presentation/cubit_controller/cart/cart.dart';
import 'package:techni_quick/presentation/widgets/car_item.dart';

import '../../injection.dart';
import '../../model/Supplies.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = sl<FirebaseAuth>().currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          tr("cart_screen"),
          style: const TextStyle(color: white),
        ),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CartSupplies>>(
              stream: CartController.getCart(userUid: userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final cartData = snapshot.data!;
                  return Column(
                    children: [
                      if (cartData.isEmpty)
                        Expanded(
                          child: Center(
                            child: Center(child: Text(tr("no_products_yet"))),
                          ),
                        )
                      else
                        Expanded(
                            child: ListView.builder(
                          itemCount: cartData.length,
                          itemBuilder: (context, index) =>
                              CartItemWidget(cartSupplies: cartData[index]),
                        )),
                      if (cartData.isNotEmpty)
                        StatefulBuilder(builder: (context, setState) {
                          if (isLoading) {
                            return const CircularProgressIndicator();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                toggleIsLoading();
                                CartController.submitCartOrder(
                                        supplies: cartData, userUid: userId)
                                    .whenComplete(() => toggleIsLoading());
                              },
                              child: Center(
                                child: Container(
                                  height: 56,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(tr('submit_cart'),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
