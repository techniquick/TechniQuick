import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constant.dart';
import '../../../core/util/size_config.dart';
import '../../../core/util/styles.dart';
import '../../../core/widgets/rating_bar.dart';
import '../../../model/tech_order.dart';
import '../../cubit_controller/tech_orders/tech_orders.dart';

class TechProfile extends StatefulWidget {
  const TechProfile(
      {Key? key,
      required this.offer,
      required this.orderId,
      required this.techRequest})
      : super(key: key);

  final String orderId;
  final TechRequest techRequest;
  final Offer offer;

  @override
  State<TechProfile> createState() => _TechProfileState();
}

class _TechProfileState extends State<TechProfile> {
  bool isLoading = false;

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(100),
              child: CircleAvatar(
                backgroundColor: white,
                radius: 72,
                child: CircleAvatar(
                    radius: 69,
                    backgroundColor: white,
                    backgroundImage:
                        NetworkImage(widget.offer.technician.image)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: Material(
                    color: mainColor,
                    elevation: 3,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              widget.offer.technician.name,
                              style:
                                  TextStyles.bodyText28.copyWith(color: white),
                            ),
                          ),
                          const Divider(color: white),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Center(
                                child: Row(
                                  children: [
                                    Text(
                                      tr("profission"),
                                      style: TextStyles.bodyText18
                                          .copyWith(color: white),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      tr(widget.offer.technician.techCategory
                                          .categoryName),
                                      style: TextStyles.bodyText18
                                          .copyWith(color: white),
                                    ),
                                  ],
                                ),
                              ),
                              widget.offer.technician.rates.isEmpty
                                  ? const CustomRating(
                                      rate: 0,
                                    )
                                  : CustomRating(
                                      rate: widget.offer.technician.rates
                                          .map((rate) => rate.rate
                                              .toDouble()
                                              .clamp(0.0, 5.0))
                                          .reduce((value, element) =>
                                              value + element),
                                    ),
                            ],
                          ),
                          const Divider(color: white),
                          SizedBox(
                            height: 50,
                            child: GridView.builder(
                                itemCount: widget.offer.technician.techCategory
                                    .subCategory.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 8,
                                        crossAxisCount: 3,
                                        mainAxisExtent: 100,
                                        mainAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return Text(
                                    tr(widget.offer.technician.techCategory
                                        .subCategory[index]),
                                    style: TextStyles.bodyText16
                                        .copyWith(color: white),
                                  );
                                }),
                          ),
                          const Divider(color: white),
                          Text(
                            tr("portfolios"),
                            style: TextStyles.bodyText18.copyWith(color: white),
                          ),
                          if (widget.offer.technician.portfolios.isEmpty)
                            Center(
                              child: Text(
                                tr("new_in_techni_quick"),
                                style: TextStyles.bodyText20
                                    .copyWith(color: white),
                              ),
                            )
                          else
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.offer.technician.portfolios.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            child: CircleAvatar(
                                              backgroundColor: white,
                                              radius: 60,
                                              child: CircleAvatar(
                                                  radius: 58,
                                                  backgroundColor: white,
                                                  backgroundImage: NetworkImage(
                                                      widget
                                                          .offer
                                                          .technician
                                                          .portfolios[index]
                                                          .image)),
                                            ),
                                          ),
                                          Text(
                                            widget
                                                .offer
                                                .technician
                                                .portfolios[index]
                                                .orderDescription,
                                            style: TextStyles.bodyText14
                                                .copyWith(color: white),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          if (widget.offer.offerStatus == OfferStatus.newOffer)
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              toggleIsLoading();
                                              TechOrderController.acceptOffer(
                                                      technician: widget
                                                          .offer.technician,
                                                      client: widget
                                                          .techRequest.endUser,
                                                      offer: widget.offer,
                                                      offerId: widget
                                                          .offer.technicianId,
                                                      orderId: widget.orderId)
                                                  .whenComplete(
                                                      () => toggleIsLoading());
                                            },
                                            child: Center(
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(tr('accept'),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white)),
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
                                              TechOrderController.rejectOffer(
                                                  technician:
                                                      widget.offer.technician,
                                                  client: widget
                                                      .techRequest.endUser,
                                                  offerId:
                                                      widget.offer.technicianId,
                                                  orderId: widget.orderId);
                                            },
                                            child: Center(
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(tr('reject'),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white)),
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
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
