import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/util/navigator.dart';

import '../../../../injection.dart';
import '../../../../model/user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Supplier? _supplier;
  Supplier get supplier => _supplier!;

  Future<void> fLogin({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      emit(LoginLoading());
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        sl<AppNavigator>().popToFrist();
      } on FirebaseAuthException catch (e) {
        emit(LoginError(
            message: e.message ?? "An error Occured ,please try again later"));
      }
    }

    emit(LoginInitial());
  }
}
