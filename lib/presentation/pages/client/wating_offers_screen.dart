import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constant.dart';
import '../../../core/util/images.dart';
import '../../../core/util/navigator.dart';
import '../../../core/util/styles.dart';
import '../../../injection.dart';
import '../../../model/tech_order.dart';
import '../../cubit_controller/tech_orders/tech_orders.dart';
import 'tech_profile.dart';

class TechOffersScreen extends StatefulWidget {
  const TechOffersScreen(
      {Key? key, required this.techRequest, required this.orderId})
      : super(key: key);
  final TechRequest techRequest;
  final String orderId;
  @override
  State<TechOffersScreen> createState() => _TechOffersScreenState();
}

class _TechOffersScreenState extends State<TechOffersScreen> {
  final TextEditingController controller = TextEditingController();
  File? imageFile;
  Future<void> setImage(File? pickedFile) async {
    if (pickedFile != null) {
      setState(() {});
      imageFile = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          tr("request_tech"),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Offer>>(
                stream: TechOrderController.getOffers(
                  orderId: widget.orderId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Lottie.asset(searchlottie);
                  } else {
                    final List<Offer> techRequesOffers = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                        itemCount: techRequesOffers.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            sl<AppNavigator>().push(
                                screen: TechProfile(
                                    techRequest: widget.techRequest,
                                    orderId: widget.orderId,
                                    offer: techRequesOffers[index]));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: darkerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            techRequesOffers[index]
                                                .technician
                                                .image,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            techRequesOffers[index]
                                                .technician
                                                .name,
                                            style: TextStyles.bodyText20
                                                .copyWith(color: white),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "${techRequesOffers[index].priceMin} ${tr("EGP")} - ${techRequesOffers[index].priceMax} ${tr("EGP")}",
                                            style: TextStyles.bodyText16
                                                .copyWith(color: white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 22,
                                      color: white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
