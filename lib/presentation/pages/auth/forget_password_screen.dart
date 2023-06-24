import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/core/util/styles.dart';
import 'package:techni_quick/core/util/toast.dart';
import 'package:techni_quick/core/util/validator.dart';
import 'package:techni_quick/core/widgets/master_text_field.dart';

import '../../../injection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth auth = sl<FirebaseAuth>();
    try {
      await auth.sendPasswordResetEmail(
        email: _emailController.text,
      );
      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
      showToast(tr("check_email"));
      sl<AppNavigator>().pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
        ),
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
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
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(top: 100),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tr("recovver_pass"),
                                style: TextStyles.bodyText18,
                              ),
                              const SizedBox(height: 32.0),
                              MasterTextField(
                                prefixIcon: const Icon(Icons.email),
                                labelText: tr("email"),
                                controller: _emailController,
                                validator: (value) => Validator.email(value),
                              ),
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _resetPassword();
                                        }
                                      },
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        tr('reset_password'),
                                        style: TextStyles.bodyText16
                                            .copyWith(color: white),
                                      ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
