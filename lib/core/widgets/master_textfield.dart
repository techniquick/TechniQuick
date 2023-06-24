import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';
import '../util/styles.dart';
import '../util/validator.dart';

class TextFormFieldBox extends StatelessWidget {
  final String text;
  final int? maxLines;
  final Color? hintColor;
  final TextEditingController? messageController;
  final String? Function(String?) validate;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  const TextFormFieldBox(
      {Key? key,
      required this.text,
      this.maxLines,
      this.hintColor,
      this.messageController,
      this.validate = Validator.defaultEmptyValidator,
      this.controller,
      this.keyboardType,
      this.isPassword,
      this.onChanged,
      this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(text, style: TextStyles.bodyText14),
          const SizedBox(height: 5),
          TextFormField(
            inputFormatters: [
              if (isPassword ?? false) NewlineTextInputFormatter()
            ],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              filled: false,
              errorMaxLines: 2,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: formFieldBorder,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: formFieldBorder,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: formFieldBorder,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: formFieldBorder,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1,
                    style: BorderStyle.solid,
                  )),
              hintStyle: TextStyles.bodyText14.copyWith(color: Colors.grey),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: maxLines ?? 8,
            textInputAction: TextInputAction.done,
            controller: messageController,
            validator: validate,
          ),
        ]);
  }
}

class NewlineTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove newline and carriage return characters from user input
    String formattedText = newValue.text.replaceAll(RegExp(r'[\n\r]'), '');

    // Return the updated text editing value
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
