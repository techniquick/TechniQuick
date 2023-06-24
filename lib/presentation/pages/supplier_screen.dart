import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constant.dart';
import '../../core/util/navigator.dart';
import '../../core/util/styles.dart';
import '../../core/widgets/cart_app_bar_icon.dart';
import '../../injection.dart';
import '../../model/user.dart';
import '../cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import '../cubit_controller/cart/cart.dart';
import '../widgets/supplies_card_widget.dart';

class SupplierScreen extends StatelessWidget {
  final Supplier supplier;

  const SupplierScreen({super.key, required this.supplier});
  _launchCaller(String url) async {
    if (await canLaunchUrl(Uri(scheme: "tel", path: url))) {
      await launchUrl(Uri(scheme: "tel", path: url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<BottomBarCubit>().user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [CartAppBarIcon(user: user)],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.name,
                  style: const TextStyle(
                    fontFamily: interFontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      supplier.phone,
                      style: const TextStyle(
                        fontFamily: interFontFamily,
                        fontSize: 16,
                        color: darkerColor,
                      ),
                    ),
                    const SizedBox(width: 50),
                    GestureDetector(
                        onTap: () {
                          _launchCaller(supplier.phone);
                        },
                        child: const Icon(
                          Icons.call,
                          color: darkerColor,
                        ))
                  ],
                ),
                Text(
                  supplier.addressCord,
                  style: const TextStyle(
                    fontFamily: interFontFamily,
                    fontSize: 16,
                    color: darkerColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: supplier.supplies.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          supplier.supplies[index].image,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  supplier.supplies[index].name,
                                  style: const TextStyle(
                                    fontFamily: interFontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                StatefulBuilder(builder: (context, setState) {
                                  bool isLoading = false;

                                  void toggleIsLoading() {
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                  }

                                  return IconButton(
                                    onPressed: () async {
                                      toggleIsLoading();
                                      await CartController.addTocart(
                                          supplies: supplier.supplies[index],
                                          userUid: user.id);
                                      toggleIsLoading();
                                    },
                                    icon: const Icon(Icons.add_shopping_cart),
                                    color: mainColor,
                                  );
                                }),
                              ],
                            ),
                            Text(
                                supplier.supplies[index].suppliesCategory
                                    .suppliesName,
                                style: TextStyles.bodyText16),
                            Text(
                                '${supplier.supplies[index].price} ${tr("EGP")}',
                                style: TextStyles.bodyText16),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        supplier.supplies[index].discription,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                PositionedDirectional(
                                  bottom: 0,
                                  end: 0,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: IconButton(
                                      onPressed: () {
                                        sl<AppNavigator>().push(
                                            screen: SuppliesWidget(
                                                supplies:
                                                    supplier.supplies[index]));
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 22,
                                        color: darkerColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  ..slideX(delay: ((index * 80) > 240 ? 240 : (index * 80)).ms)
                      .fadeIn();
              },
            ),
          ),
        ],
      ),
    );
  }
}
