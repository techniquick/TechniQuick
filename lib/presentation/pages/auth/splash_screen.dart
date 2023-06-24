import 'package:flutter/material.dart';

import '../../../core/util/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Image.asset(
          logo,
          height: 300,
        )),
      ]),
    );
  }
}
