import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/presentation/pages/client/complete_tech_order.dart';

import '../../../injection.dart';

class TechOrder extends StatefulWidget {
  const TechOrder({Key? key}) : super(key: key);

  @override
  State<TechOrder> createState() => _TechOrderState();
}

class _TechOrderState extends State<TechOrder> {
  final List<String> jobList = [
    "plumbing",
    "carpentry",
    "painting",
    "electrical",
    "metalwork",
    "drywall",
    "plastering",
    "nursing",
    "ceramics",
    "shower",
    "air_conditioning"
  ];

  final Map<String, List<String>> professionList = {
    "plumbing": ["pipefitter", "plumber", "draincleaner"],
    "carpentry": ["cabinetmaker", "trimcarpenter", "furnituremaker"],
    "painting": ["housepainter", "commercialpainter", "industrialpainter"],
    "electrical": ["electrician", "electricalengineer", "powerlineman"],
    "metalwork": ["blacksmith", "metalfabricator", "sheetmetalworker"],
    "drywall": ["drywaller", "taper", "plasterer"],
    "plastering": ["plasterer", "stuccomason", "ornamentalplasterer"],
    "nursing": [
      "registerednurse",
      "licensedpracticalnurse",
      "nursepractitioner"
    ],
    "ceramics": ["ceramicartist", "tilesetter", "glazespecialist"],
    "shower": ["showerinstaller", "showerrepairspecialist", "showerdesigner"],
    "air_conditioning": [
      "HVACtechnician",
      "refrigerationmechanic",
      "ductworkinstaller"
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("request_tech"),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              tr("select_category"),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: GridView.builder(
              itemCount: jobList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 8,
                  crossAxisCount: 2,
                  mainAxisExtent: 100,
                  mainAxisSpacing: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => sl<AppNavigator>()
                      .push(screen: CompleteTechOrder(job: jobList[index])),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: mainColor.withOpacity(0.8),
                        ),
                      ),
                      Center(
                        child: Text(
                          tr(jobList[index]),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  ..slideX(delay: ((index * 80) > 240 ? 240 : (index * 80)).ms)
                      .fadeIn();
              },
            ))
          ],
        ),
      ),
    );
  }
}
