import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:techni_quick/chat/domain/entities/order_user.dart';
import 'package:techni_quick/chat/presentation/pages/chat_page.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/model/tech_order.dart';
import 'package:techni_quick/model/user.dart';
import 'package:techni_quick/presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import 'package:techni_quick/presentation/pages/client/wating_offers_screen.dart';
import 'package:techni_quick/presentation/pages/supplies_from_cart_screen.dart';
import 'package:techni_quick/presentation/pages/technican/tech_order_details_screem.dart';

import '../../../core/constant/constant.dart';
import '../../chat/presentation/provider/chat_provider.dart';
import '../../core/constant.dart';
import '../../core/util/styles.dart';
import '../../core/widgets/master_textfield.dart';
import '../../injection.dart';
import '../../model/cart_order.dart';
import '../cubit_controller/my_orders/my_orders_cubit.dart';
import '../cubit_controller/rate/rate_cubit.dart';
import '../widgets/rate.dart';
import 'client/tech_profile.dart';

import 'package:flutter/material.dart';

enum OrderType { cart_orders, tech_orders }

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final user = sl<BottomBarCubit>().user;
    return Scaffold(
      body: SizedBox(
        height: height(context),
        width: width(context),
        child: Stack(
          children: [
            Material(
              elevation: 5,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SizedBox(
                height: height(context),
                width: width(context),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    if (user.type != UserType.supplier) const MyOrderType(),
                    const MyOrderStatus(),
                    Expanded(
                      child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
                        builder: (context, state) {
                          final cubit = context.watch<MyOrdersCubit>();
                          return StreamBuilder<List<BaseOrder>>(
                              stream: context
                                  .read<MyOrdersCubit>()
                                  .fGetCartOrders(type: user.type),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                final orders = snapshot.data!;
                                if (orders.isEmpty) {
                                  return Center(
                                      child: Text(tr("no_orders_yet")));
                                }
                                if (cubit.selectedType ==
                                    OrderType.cart_orders) {
                                  return ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) =>
                                          OrderSummaryWidget(
                                            cartOrder:
                                                orders[index] as CartOrder,
                                          ).animate()
                                            ..slideX(
                                                    delay: ((index * 80) > 240
                                                            ? 240
                                                            : (index * 80))
                                                        .ms)
                                                .fadeIn());
                                } else {
                                  return ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) =>
                                          TechSummaryWidget(
                                            techRequest:
                                                orders[index] as TechRequest,
                                          ).animate()
                                            ..slideX(
                                                    delay: ((index * 80) > 240
                                                            ? 240
                                                            : (index * 80))
                                                        .ms)
                                                .fadeIn());
                                }
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyOrderStatus extends StatefulWidget {
  const MyOrderStatus({Key? key}) : super(key: key);

  @override
  State<MyOrderStatus> createState() => _MyOrderStatusState();
}

class _MyOrderStatusState extends State<MyOrderStatus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOrdersCubit, MyOrdersState>(
      builder: (context, state) {
        final cubit = context.watch<MyOrdersCubit>();
        final selectedStatus = cubit.selectedStatus;
        final listOrderStatus = cubit.listOrderStatus();
        return SizedBox(
            height: 50,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                controller: cubit.controller,
                scrollDirection: Axis.horizontal,
                itemCount: listOrderStatus.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context
                      .read<MyOrdersCubit>()
                      .changeSelectedStatus(newStatus: listOrderStatus[index]),
                  child: Container(
                    height: 62,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectedStatus == listOrderStatus[index]
                            ? darkerColor.withOpacity(.3)
                            : white,
                        borderRadius: borderRadius,
                        border: Border.all(
                            color: selectedStatus == listOrderStatus[index]
                                ? white
                                : formFieldBorder,
                            width: 1)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Center(
                      child: Text(
                        tr(listOrderStatus[index].name),
                        style: TextStyles.bodyText14.copyWith(
                            color: selectedStatus == listOrderStatus[index]
                                ? darkerColor
                                : Colors.grey,
                            fontWeight: selectedStatus == listOrderStatus[index]
                                ? FontWeight.bold
                                : FontWeight.w400),
                      ),
                    ),
                  ),
                ).animate()
                  ..slideX(delay: ((index * 80) > 240 ? 240 : (index * 80)).ms)
                      .fadeIn(),
              ),
            ));
      },
    );
  }
}

class MyOrderType extends StatefulWidget {
  const MyOrderType({Key? key}) : super(key: key);

  @override
  State<MyOrderType> createState() => _MyOrderTypeState();
}

class _MyOrderTypeState extends State<MyOrderType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MyOrdersCubit>();
    final user = context.watch<BottomBarCubit>().user;
    final selectedType = cubit.selectedType;
    final listOrderType = cubit.listOrderType;
    return SizedBox(
        height: 50,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            controller: cubit.controllerType,
            scrollDirection: Axis.horizontal,
            itemCount: listOrderType.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context
                  .read<MyOrdersCubit>()
                  .changeSelectedType(newStatus: listOrderType[index]),
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: borderRadius,
                    border: Border.all(
                        color: selectedType == listOrderType[index]
                            ? white
                            : formFieldBorder,
                        width: 1)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Center(
                  child: Text(
                    tr(listOrderType[index].name +
                        (user.type == UserType.technician ? "T" : "")),
                    style: TextStyles.bodyText14.copyWith(
                        color: selectedType == listOrderType[index]
                            ? darkerColor
                            : Colors.grey,
                        fontWeight: selectedType == listOrderType[index]
                            ? FontWeight.bold
                            : FontWeight.w400),
                  ),
                ),
              ),
            ).animate()
              ..slideX(delay: ((index * 80) > 240 ? 240 : (index * 80)).ms)
                  .fadeIn(),
          ),
        ));
  }
}

class OrderSummaryWidget extends StatelessWidget {
  final CartOrder cartOrder;

  const OrderSummaryWidget({
    Key? key,
    required this.cartOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = sl<BottomBarCubit>().user;
    final totalPrice = cartOrder.cartSupplies
        .map((e) => int.parse(e.price))
        .toList()
        .fold(0, (previousValue, element) => previousValue + element);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(cartOrder.createdAt),
                          style: TextStyles.bodyText20),
                      const SizedBox(height: 8.0),
                      Text('${totalPrice.toStringAsFixed(2)} ${tr("EGP")}',
                          style: TextStyles.bodyText16),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        sl<AppNavigator>().push(
                            screen: SuppliesCartScreen(
                          supplies: cartOrder.cartSupplies,
                        ));
                      },
                      child: Center(
                        child: Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(tr('supplies'),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(cartOrder.address, style: TextStyles.bodyText14),
              const SizedBox(height: 8.0),
              if (user.type != UserType.supplier &&
                  cartOrder.status == OrderStatus.newOrder)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AppDialog(
                                      title: tr("are_you_sure"),
                                      function: () async {
                                        sl<AppNavigator>().pop();
                                        context
                                            .read<MyOrdersCubit>()
                                            .cancelOrder(
                                              enduser: user,
                                              supplier: cartOrder.supplierUser
                                                  as Supplier,
                                              orderId: cartOrder.id,
                                            );
                                      }));
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(tr('cancel'),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              if (user.type == UserType.supplier &&
                  cartOrder.status == OrderStatus.processing)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AppDialog(
                                      title: tr("are_you_sure"),
                                      function: () async {
                                        sl<AppNavigator>().pop();
                                        context
                                            .read<MyOrdersCubit>()
                                            .supplierChangeOrderStatus(
                                                enduser: cartOrder.endUser,
                                                supplier: user as Supplier,
                                                docId: cartOrder.id,
                                                newOrderStatus:
                                                    OrderStatus.finished);
                                      }));
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(tr('finish'),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              if (user.type == UserType.supplier &&
                  cartOrder.status == OrderStatus.newOrder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AppDialog(
                                    title: tr("are_you_sure"),
                                    function: () async {
                                      sl<AppNavigator>().pop();
                                      context
                                          .read<MyOrdersCubit>()
                                          .supplierChangeOrderStatus(
                                              enduser: cartOrder.endUser,
                                              supplier: user as Supplier,
                                              docId: cartOrder.id,
                                              newOrderStatus:
                                                  OrderStatus.processing);
                                    }));
                          },
                          child: Center(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(tr('accept'),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AppDialog(
                                    title: tr("are_you_sure"),
                                    function: () async {
                                      sl<AppNavigator>().pop();
                                      context
                                          .read<MyOrdersCubit>()
                                          .supplierChangeOrderStatus(
                                              enduser: cartOrder.endUser,
                                              supplier: user as Supplier,
                                              docId: cartOrder.id,
                                              newOrderStatus:
                                                  OrderStatus.canceled);
                                    }));
                          },
                          child: Center(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(tr('cancel'),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class TechSummaryWidget extends StatelessWidget {
  final TechRequest techRequest;

  const TechSummaryWidget({
    Key? key,
    required this.techRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = sl<BottomBarCubit>().user;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(techRequest.createdAt),
                          style: TextStyles.bodyText20),
                      const SizedBox(height: 8.0),
                      if (techRequest.currentOffer != null)
                        Text(
                            '${techRequest.currentOffer?.finalPrice} ${tr("EGP")}',
                            style: TextStyles.bodyText16),
                    ],
                  ),
                  if (user.type == UserType.technician &&
                      techRequest.status == OrderStatus.processing)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              sl<AppNavigator>().push(
                                  screen: TectOrderDetailsScreen(
                                techRequest: techRequest,
                              ));
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(tr('details'),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              sl<AppNavigator>().push(
                                screen: ChangeNotifierProvider<ChatProvider>(
                                  create: (_) => sl<ChatProvider>(),
                                  child: ChatPage(
                                    user2: ChatUser.fromAppUser(
                                        techRequest.endUser),
                                    user1: ChatUser.fromAppUser(
                                        techRequest.currentOffer!.technician),
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.message),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  if (user.type == UserType.client &&
                      techRequest.status == OrderStatus.finished &&
                      !techRequest.isRate!)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => RateAccountDialog(
                              techOrSup: techRequest.currentOffer!.technician,
                              userUid: techRequest.currentOffer!.technicianId,
                              orderId: techRequest.id,
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(tr('order_rate'),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (user.type == UserType.client &&
                      techRequest.status == OrderStatus.processing)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              sl<AppNavigator>().push(
                                  screen: TechProfile(
                                techRequest: techRequest,
                                offer: techRequest.currentOffer!,
                                orderId: techRequest.id,
                              ));
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(tr('technican'),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              sl<AppNavigator>().push(
                                screen: ChangeNotifierProvider<ChatProvider>(
                                  create: (_) => sl<ChatProvider>(),
                                  child: ChatPage(
                                    user1: ChatUser.fromAppUser(
                                        techRequest.endUser),
                                    user2: ChatUser.fromAppUser(
                                        techRequest.currentOffer!.technician),
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.message),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  if (user.type == UserType.client &&
                      techRequest.status == OrderStatus.newOrder)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          sl<AppNavigator>().push(
                              screen: TechOffersScreen(
                            techRequest: techRequest,
                            orderId: techRequest.id,
                          ));
                        },
                        child: Center(
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(tr('offers'),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(techRequest.address, style: TextStyles.bodyText14),
              const SizedBox(height: 8.0),
              if (user.type == UserType.client &&
                  techRequest.status == OrderStatus.newOrder)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AppDialog(
                                    title: tr("are_you_sure"),
                                    function: () async {
                                      sl<AppNavigator>().pop();
                                      context.read<MyOrdersCubit>().cancelOrder(
                                          enduser: user,
                                          orderId: techRequest.id);
                                    }),
                              );
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(tr('cancel'),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}

class RateAccountDialog extends StatefulWidget {
  const RateAccountDialog({
    super.key,
    required this.orderId,
    required this.techOrSup,
    required this.userUid,
  });
  final String userUid;
  final BaseUser techOrSup;
  final String orderId;

  @override
  State<RateAccountDialog> createState() => _RateAccountDialogState();
}

class _RateAccountDialogState extends State<RateAccountDialog> {
  bool isLoading = false;
  int? rate;
  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Column(
        children: [
          Text(tr("order_rate"), style: TextStyles.bodyText18),
          const SizedBox(height: 15),
          ratingBar(
              startRate: 1,
              size: 30,
              onRatingUpdate: (value) {
                rate = value.toInt();
              }),
          const SizedBox(height: 15),
          TextFormFieldBox(
            text: "",
            maxLines: 4,
            messageController: controller,
          ),
          isLoading
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<RateCubit, RateState>(
                        builder: (context, logoutState) {
                      return TextButton(
                          onPressed: () async {
                            if (rate == null || controller.text.isEmpty) {
                              tr("rate_note");
                              return;
                            }
                            toggleIsLoading();
                            await context.read<RateCubit>().fRate(
                                userUid: widget.techOrSup.id,
                                techOrSup: widget.techOrSup,
                                rateNumber: rate!,
                                comment: controller.text,
                                orderId: widget.orderId);

                            toggleIsLoading();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                                color: darkerColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                tr("rate"),
                                style: TextStyles.bodyText14
                                    .copyWith(color: white),
                              ),
                            ),
                          ));
                    }),
                  ],
                )
        ],
      ),
    );
  }
}

Widget ratingBar(
    {required double startRate,
    double size = 15,
    void Function(double)? onRatingUpdate}) {
  return RatingBar(
    initialRating: startRate,
    minRating: 1, ignoreGestures: onRatingUpdate == null ? true : false,
    direction: Axis.horizontal,
    allowHalfRating: false,
    itemCount: 5,
    itemSize: size,
    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
    ratingWidget: RatingWidget(
      full: const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      empty: Icon(
        Icons.star,
        color: Colors.grey[100],
      ),
      half: Icon(
        Icons.star_half,
        color: Colors.grey[100],
      ),
    ),
    onRatingUpdate: onRatingUpdate ?? (rating) {},
    // updateOnDrag: true,
  );
}
