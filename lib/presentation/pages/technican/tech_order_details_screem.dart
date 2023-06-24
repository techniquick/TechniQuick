import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/common/get_image.dart';
import '../../../core/constant.dart';
import '../../../core/util/images.dart';
import '../../../core/util/navigator.dart';
import '../../../core/util/size_config.dart';
import '../../../core/util/styles.dart';
import '../../../core/util/toast.dart';
import '../../../core/util/validator.dart';
import '../../../core/widgets/master_text_field.dart';
import '../../../injection.dart';
import '../../../model/cart_order.dart';
import '../../../model/tech_order.dart';
import '../../../model/user.dart';
import '../../cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import '../../cubit_controller/tech_orders/tech_orders.dart';
import '../../widgets/rate.dart';

class TectOrderDetailsScreen extends StatefulWidget {
  const TectOrderDetailsScreen({Key? key, required this.techRequest})
      : super(key: key);
  final TechRequest techRequest;
  @override
  State<TectOrderDetailsScreen> createState() => _TectOrderDetailsScreenState();
}

class _TectOrderDetailsScreenState extends State<TectOrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final finalpriceController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  File? imageFile;
  Future<void> setImage(File? pickedFile) async {
    if (pickedFile != null) {
      setState(() {});
      imageFile = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  bool isLoading = false;

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final techUser = context.watch<BottomBarCubit>().user as Technician;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Form(
          key: _formKey,
          child: Stack(children: [
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25),
                            if (widget.techRequest.image != null &&
                                widget.techRequest.image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: borderRadius,
                                child: Image.network(
                                  widget.techRequest.image!,
                                  fit: BoxFit.fill,
                                  height: SizeConfig.blockSizeVertical * 30,
                                  width: SizeConfig.blockSizeHorizontal * 70,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr("problem_det"),
                                  style: TextStyles.bodyText20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String lat = widget.techRequest.addressCord
                                        .split(",")[0];
                                    String long = widget.techRequest.addressCord
                                        .split(",")[1];

                                    Uri googleUrl = Uri.parse(
                                        'comgooglemaps://?center=$lat,$long');
                                    Uri appleUrl = Uri.parse(
                                        'https://www.google.com/maps/search/?api=1&query=$lat,$long');
                                    if (await canLaunchUrl(
                                        Uri.parse("comgooglemaps://"))) {
                                      await launchUrl(googleUrl,
                                          mode: LaunchMode.externalApplication);
                                    } else if (await canLaunchUrl(appleUrl)) {
                                      await launchUrl(appleUrl,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      throw 'Could not launch url';
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.map, color: white),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.techRequest.problemDetails,
                              style: TextStyles.bodyText16,
                            ),
                            const SizedBox(height: 30),
                            if (widget.techRequest.status ==
                                OrderStatus.processing)
                              Column(children: [
                                Text(
                                  tr("add_teck_photo"),
                                  style: TextStyles.bodyText18,
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: SizedBox(
                                            height: 250,
                                            width: double.infinity,
                                            child: imageFile != null
                                                ? Image.file(
                                                    imageFile!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    logo,
                                                    fit: BoxFit.cover,
                                                  )),
                                      ),
                                      Positioned(
                                          bottom: 10,
                                          left: 5,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  elevation: 3,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  )),
                                                  context: context,
                                                  builder: (_) {
                                                    return GetImageFromCameraAndGellary(
                                                        onPickImage: (img) {
                                                      setImage(img);
                                                    });
                                                  });
                                            },
                                            child: const Icon(
                                              Icons.add_a_photo,
                                              color: Colors.grey,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "${widget.techRequest.currentOffer!.priceMax} ${tr("EGP")} - ${widget.techRequest.currentOffer!.priceMin} ${tr("EGP")}",
                                  style: TextStyles.bodyText18,
                                ),
                                Text(
                                  tr("type_your_final_price"),
                                  style: TextStyles.bodyText18,
                                ),
                                const SizedBox(height: 10),
                                MasterTextField(
                                    keyType: TextInputType.number,
                                    controller: finalpriceController,
                                    validator: (value) =>
                                        Validator.numbers(value),
                                    labelText: tr('type_your_final_price'),
                                    prefixIcon: const Icon(
                                        Icons.monetization_on_outlined)),
                                isLoading
                                    ? const CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            if (int.parse(finalpriceController
                                                        .text) <
                                                    int.parse(widget
                                                        .techRequest
                                                        .currentOffer!
                                                        .priceMin) ||
                                                int.parse(finalpriceController
                                                        .text) >
                                                    int.parse(widget
                                                        .techRequest
                                                        .currentOffer!
                                                        .priceMax)) {
                                              showToast(tr("price_in_range"));
                                              return;
                                            }
                                            showDialog(
                                                context: context,
                                                builder: (context) => AppDialog(
                                                    title: tr("are_you_sure"),
                                                    function: () async {
                                                      sl<AppNavigator>().pop();
                                                      TechOrderController.finishOrder(
                                                          technician: widget
                                                              .techRequest
                                                              .currentOffer!
                                                              .technician,
                                                          client: widget
                                                              .techRequest
                                                              .endUser,
                                                          image: imageFile,
                                                          orderId: widget
                                                              .techRequest.id,
                                                          finalPrice:
                                                              finalpriceController
                                                                  .text,
                                                          techRequest: widget
                                                              .techRequest);
                                                    }));
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(tr('finish'),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ]),
                            if (widget.techRequest.status ==
                                OrderStatus.newOrder)
                              Column(
                                children: [
                                  Text(
                                    tr("type_your_price_offer_range"),
                                    style: TextStyles.bodyText20,
                                  ),
                                  MasterTextField(
                                      keyType: TextInputType.number,
                                      controller: minPriceController,
                                      validator: (value) => Validator.price(
                                          value, maxPriceController.text),
                                      labelText: tr('min_price'),
                                      prefixIcon: const Icon(Icons.minimize)),
                                  MasterTextField(
                                      keyType: TextInputType.number,
                                      controller: maxPriceController,
                                      validator: (value) => Validator.priceMax(
                                          value, minPriceController.text),
                                      labelText: tr('max_price'),
                                      prefixIcon: const Icon(Icons.add)),
                                  Text(
                                    tr("we_will_notify_you_when_our_customer_accepts_your_offer"),
                                    textAlign: TextAlign.center,
                                    style: TextStyles.bodyText14,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        toggleIsLoading();
                                        TechOrderController.acceptOrder(
                                                client:
                                                    widget.techRequest.endUser,
                                                orderId: widget.techRequest.id,
                                                technician: techUser,
                                                priceMin:
                                                    minPriceController.text,
                                                priceMax:
                                                    maxPriceController.text)
                                            .whenComplete(
                                                () => toggleIsLoading());
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 40,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(tr('send_offer'),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                          ],
                        )),
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
