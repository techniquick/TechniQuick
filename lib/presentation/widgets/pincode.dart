import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:techni_quick/core/constant.dart';

import '../../core/util/validator.dart';

class PinCode extends StatefulWidget {
  const PinCode({Key? key, required this.codeController}) : super(key: key);
  final TextEditingController codeController;

  @override
  State<PinCode> createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        controller: widget.codeController,
        errorTextSpace: 30,
        appContext: context,
        length: 4,
        pinTheme: PinTheme(
          selectedFillColor: mainColor.withOpacity(.05),
          selectedColor: mainColor,
          inactiveFillColor: white,
          disabledColor: mainColor,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10.r),
          borderWidth: 1,
          inactiveColor: darkerColor,
          activeColor: Colors.transparent,
          fieldHeight: 100.h,
          fieldWidth: 70.w,
          activeFillColor: mainColor.withOpacity(0.1),
        ),
        cursorColor: white,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        validator: (value) => Validator.defaultValidator(value),
        keyboardType: TextInputType.number,
        onCompleted: (v) {
          debugPrint("Completed");
        },
        onChanged: (value) {
          debugPrint(value);
        },
      ),
    );
  }
}
