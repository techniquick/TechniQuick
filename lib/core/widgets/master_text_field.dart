import 'package:flutter/material.dart';
import 'package:techni_quick/core/util/styles.dart';

import 'master_textfield.dart';

class MasterTextField extends StatefulWidget {
  final TextEditingController controller;
  final dynamic validator;
  final String labelText;
  final Icon prefixIcon;
  final bool isPassword;
  final TextInputType? keyType;
  const MasterTextField({
    super.key,
    required this.controller,
    this.keyType,
    this.validator,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
  });

  @override
  State<MasterTextField> createState() => _MasterTextFieldState();
}

class _MasterTextFieldState extends State<MasterTextField> {
  bool isSecure = false;
  @override
  void initState() {
    super.initState();
    isSecure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: isSecure,
        keyboardType: widget.keyType,
        inputFormatters: [if (widget.isPassword) NewlineTextInputFormatter()],
        style: const TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          errorStyle: TextStyles.bodyText16.copyWith(color: Colors.red),
          contentPadding: const EdgeInsets.all(12),
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black),
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isSecure = !isSecure;
                    });
                  },
                  child: isSecure == false
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
