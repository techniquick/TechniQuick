import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:techni_quick/core/util/styles.dart';

import '../../../core/constant.dart';
import '../../../core/util/navigator.dart';
import '../../../injection.dart';

class OfferSentScreen extends StatelessWidget {
  const OfferSentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          tr("your_offer_sent_successfully"),
          style: TextStyles.bodyText20,
        ),
        const SizedBox(height: 70),
        Image.asset(
          "assets/images/offer_sent.png",
          fit: BoxFit.cover,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 40),
        const Divider(
          height: 5,
          color: Colors.grey,
        ),
        Text(
          tr("we_will_notify_you_when_our_customer_accepts_your_offer"),
          textAlign: TextAlign.center,
          style: TextStyles.bodyText16,
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              sl<AppNavigator>().popToFrist();
            },
            child: Center(
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(tr('back'),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ),
            ),
          ),
        )
      ]),
    ));
  }
}
