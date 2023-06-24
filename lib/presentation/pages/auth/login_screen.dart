import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/injection.dart';
import 'package:techni_quick/presentation/pages/auth/forget_password_screen.dart';
import 'package:techni_quick/presentation/pages/auth/register_screen.dart';

import '../../../core/util/validator.dart';
import '../../../../core/widgets/master_text_field.dart';
import '../../../../model/user.dart';
import '../../../core/widgets/show_snack_bar.dart';
import '../../cubit_controller/auth/login/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  final UserType type;
  const LoginScreen({super.key, required this.type});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
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
              Positioned.fill(
                right: 0,
                left: 0,
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        tr('log_in'),
                                        style: myTheme.textTheme.headlineSmall!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    MasterTextField(
                                      controller: emailController,
                                      isPassword: false,
                                      labelText: tr("email"),
                                      prefixIcon: const Icon(Icons.email,
                                          color: Colors.black),
                                      validator: (value) =>
                                          Validator.email(value),
                                    ),
                                    MasterTextField(
                                      controller: passwordController,
                                      isPassword: true,
                                      labelText: tr("password"),
                                      prefixIcon: const Icon(Icons.lock,
                                          color: Colors.black),
                                      validator: (value) =>
                                          Validator.password(value),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        sl<AppNavigator>().push(
                                            screen:
                                                const ForgotPasswordScreen());
                                      },
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          tr('forget_password'),
                                          style: myTheme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocConsumer<LoginCubit, LoginState>(
                                      listener: (context, state) {
                                        if (state is LoginError) {
                                          showSnackBar(
                                              context: context,
                                              message: state.message);
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is LoginLoading) {
                                          return const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive());
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            context.read<LoginCubit>().fLogin(
                                                  context: context,
                                                  formKey: formKey,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                );
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 56,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(tr('sign_in'),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () {
                                        sl<AppNavigator>().push(
                                            screen: RegisterScreen(
                                                type: widget.type));
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(tr('dont_have_account'),
                                                style: myTheme
                                                    .textTheme.bodyLarge),
                                            const SizedBox(width: 10),
                                            Text(
                                              tr('register_now'),
                                              style: myTheme.textTheme.bodyLarge
                                                  ?.copyWith(color: mainColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 200)
            ],
          )),
    );
  }
}
