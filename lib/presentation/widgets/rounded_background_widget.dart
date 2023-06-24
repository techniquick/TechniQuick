import 'package:flutter/material.dart';

import '../../core/constant.dart';

class RoundedBackgorund extends StatelessWidget {
  const RoundedBackgorund({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Material(
        elevation: 5,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
        child: Container(
          height: 300,
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
      child
    ]);
  }
}
