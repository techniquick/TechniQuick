import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/constant.dart';
import '../../core/util/navigator.dart';
import '../../core/util/styles.dart';
import '../../injection.dart';
import '../../model/Supplies.dart';
import '../widgets/supplies_card_widget.dart';

class SuppliesCartScreen extends StatelessWidget {
  const SuppliesCartScreen({Key? key, required this.supplies})
      : super(key: key);
  final List<Supplies> supplies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: supplies.length,
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
                          supplies[index].image,
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
                                  supplies[index].name,
                                  style: const TextStyle(
                                    fontFamily: interFontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                tr(supplies[index]
                                    .suppliesCategory
                                    .suppliesName),
                                style: TextStyles.bodyText16),
                            Text('${supplies[index].price} ${tr("EGP")}',
                                style: TextStyles.bodyText16),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        supplies[index].discription,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: IconButton(
                                      onPressed: () {
                                        sl<AppNavigator>().push(
                                            screen: SuppliesWidget(
                                                supplies: supplies[index]));
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
