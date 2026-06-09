import 'package:get/get.dart';

abstract class Validators {
  static String? none() => null;

  static String? validateEmpty(String? v) {
    if (v!.isEmpty) {
      return 'Field can\'t be empty';
    } else {
      return null;
    }
  }

  static String? validatePhone(String? v, {int minLength = 10}) {
    RegExp regex = RegExp(r'^[1-9]\d{10}$');

    if (v!.isEmpty) {
      return 'Phone number can\'t be empty';
    } else if (v.length < minLength) {
      return 'Enter valid phone number';
    } else if (!v.isNumericOnly && !regex.hasMatch(v)) {
      return 'Enter valid phone number';
    }
    return null;
  }
}