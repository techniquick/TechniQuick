import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/injection.dart';
import 'package:techni_quick/model/user.dart';
import 'package:techni_quick/presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import 'package:techni_quick/presentation/pages/profile_screen.dart';
import 'package:techni_quick/presentation/pages/supplier_screen.dart';

import '../../core/widgets/cart_app_bar_icon.dart';
import '../../firebase/auth/auth_stream.dart';
import '../../model/Supplies.dart';
import '../cubit_controller/supplier/get_supplies/get_supplies.dart';
import '../widgets/ads_slider_widget.dart';
import '../widgets/main_white_cover.dart';
import '../widgets/supplies_card_widget.dart';
import 'notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    updateFcm(sl<BottomBarCubit>().user.id);
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<BottomBarCubit>().user;
    return Scaffold(
      body: Column(
        children: [
          Container(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(width: 8),
                TextButton.icon(
                  label: Text(
                    tr("my_account"),
                    style: const TextStyle(
                      fontSize: 18,
                      color: darkerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.account_circle, color: darkerColor),
                  onPressed: () {
                    sl<AppNavigator>()
                        .push(
                            screen: ProfileScreen(
                          baseUser: user,
                        ))
                        .whenComplete(() => setState(() {}));
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    sl<AppNavigator>().push(screen: const NotificationScreen());
                  },
                ),
                Container(width: 8),
                if (user.type != UserType.supplier) CartAppBarIcon(user: user),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AdsCard().animate().fadeIn(),
                    const SizedBox(height: 8),
                    MainAndWhiteCover(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.jm().format(DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const Spacer(),
                                const Icon(Icons.date_range, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.E().format(DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(),
                    if (user.type == UserType.supplier)
                      const SupplierItemsWidget().animate().fadeIn(),
                    if (user.type == UserType.client ||
                        user.type == UserType.technician)
                      const ClientandTechSupplierWidget().animate().fadeIn(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupplierItemsWidget extends StatelessWidget {
  const SupplierItemsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Supplies>>(
        stream: GetSupplies.getMySupplies(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  tr("you_dont_have_supplies"),
                  style: const TextStyle(
                    color: darkerColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          final supplies = snapshot.data!;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                child: Text(
                  tr("my_supplies"),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              MainAndWhiteCover(
                child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: supplies.length,
                      itemBuilder: (context, index) {
                        final item = supplies[index];
                        return GestureDetector(
                          onTap: () => sl<AppNavigator>()
                              .push(screen: SuppliesWidget(supplies: item)),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(item.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          );
        });
  }
}

class ClientandTechSupplierWidget extends StatelessWidget {
  const ClientandTechSupplierWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Supplier>>(
        stream: GetSupplies.getSupplier(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center();
          }
          final suppliers = snapshot.data!;
          return Column(
            children: [
              Container(
                child: Text(
                  tr("suppliers"),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              MainAndWhiteCover(
                child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = suppliers[index];
                        return GestureDetector(
                          onTap: () => sl<AppNavigator>()
                              .push(screen: SupplierScreen(supplier: supplier)),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(supplier.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    supplier.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          );
        });
  }
}
