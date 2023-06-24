import 'package:easy_localization/easy_localization.dart';
import 'package:techni_quick/core/util/toast.dart';

class Validator {
  static String? defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr("error_field_required");
    }
    return null;
  }

  static String? name(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
    }
    return null;
  }

  static String? text(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return tr("enter_correct_text");
      }
    }
    return null;
  }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return tr("error_field_required");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (value.length < 8) {
        return tr("error_password_length");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return tr("error_field_required");
      } else if (confirmPassword != password) {
        return tr("error_wrong_password_confirm");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? phone(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!value.startsWith('01') || value.length != 11) {
        return tr("error_wrong_input");
      }
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      if (value.startsWith("+")) {
        value = value.replaceFirst(r'+', "");
      }
      final number = int.tryParse(value);
      if (number == null) {
        return tr("error_wrong_input");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? nationalId(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      if (value.startsWith("+")) {
        value = value.replaceFirst(r'+', "");
      }
      final number = int.tryParse(value);
      if (number == null) {
        return tr("error_wrong_input");
      }
      if (number.toString().length != 14) {
        return tr("error_wrong_input");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? price(String? value, String? max) {
    if (value != null && max != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      final number = int.tryParse(value);
      if (number == null || number < 0) {
        return tr("error_wrong_input");
      }
      if (max.isNotEmpty) {
        final maxNumber = int.tryParse(max);
        if (maxNumber == null || maxNumber < number) {
          showToast(tr("low_price_must"));
          return tr("error_wrong_input");
        }
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? priceMax(String? value, String? min) {
    if (value != null && min != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      final number = int.tryParse(value);
      if (number == null || number < 0) {
        return tr("error_wrong_input");
      }
      final minNumber = int.tryParse(min);
      if (minNumber == null || minNumber < 0 && minNumber > number) {
        showToast(tr("low_price_must"));
        return tr("error_wrong_input");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }
}
