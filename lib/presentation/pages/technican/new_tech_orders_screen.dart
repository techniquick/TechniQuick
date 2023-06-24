import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constant.dart';
import '../../../core/util/images.dart';
import '../../../core/util/navigator.dart';
import '../../../core/util/size_config.dart';
import '../../../core/util/styles.dart';
import '../../../firebase/auth/auth_stream.dart';
import '../../../firebase/firebase_routes.dart';
import '../../../injection.dart';
import '../../../model/tech_order.dart';
import '../../../model/user.dart';
import '../../cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import '../../cubit_controller/tech_orders/tech_orders.dart';
import 'tech_order_details_screem.dart';

class NewTechOrders extends StatefulWidget {
  const NewTechOrders({Key? key}) : super(key: key);

  @override
  State<NewTechOrders> createState() => _NewTechOrdersState();
}

class _NewTechOrdersState extends State<NewTechOrders> {
  bool isOnline = true;

  void toggleIsLoading() {
    setState(() {
      isOnline = !isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<BottomBarCubit>().user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          tr("tech_orders_req"),
          style: const TextStyle(color: white),
        ),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<bool>(
          stream: getUserData(user.id)
              .map((event) => (event as Technician).isOnline),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
                child: SwitchListTile(
                  value: snapshot.data!,
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  onChanged: (value) {
                    sl<FirebaseFirestore>()
                        .doc(FirebaseRoute.userRoute(user.id))
                        .update({"is_online": !snapshot.data!});
                  },
                  title: Center(
                    child: Text(
                      snapshot.data! ? tr("online") : tr("offline"),
                      style: TextStyles.bodyText18.copyWith(color: white),
                    ),
                  ),
                ),
              ),
              if (!snapshot.data!)
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(offlinelottie),
                  ],
                )),
              if (snapshot.data!)
                Expanded(
                    child: StreamBuilder<List<TechRequest>>(
                  stream: TechOrderController.getNewTechRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(searchlottie),
                          Text(
                            tr("searching"),
                            style: TextStyles.bodyText18,
                          ),
                        ],
                      );
                    }
                    final orders = snapshot.data!;
                    return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (orders[index].image != null &&
                                            orders[index].image!.isNotEmpty)
                                          ClipRRect(
                                            borderRadius: borderRadius,
                                            child: Image.network(
                                              orders[index].image!,
                                              fit: BoxFit.fill,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      20,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  40,
                                            ),
                                          ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  orders[index].endUser.name,
                                                  style: TextStyles.bodyText18,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  tr(orders[index]
                                                      .categoryName),
                                                  style: TextStyles.bodyText16,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  orders[index].address,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyles.bodyText12,
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      sl<AppNavigator>().push(
                                                          screen:
                                                              TectOrderDetailsScreen(
                                                                  techRequest:
                                                                      orders[
                                                                          index]));
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: mainColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              tr('details'),
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ));
                  },
                ))
            ]);
          }),
    );
  }
}
