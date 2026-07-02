
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_form_field/phone_form_field.dart';

class DValidator {
  /// Max character limit for all text fields
  static const int maxTextLength = 100;

  static const int minNeet = 0;
  static const int maxNeet = 720;

  // ── Generic empty check ───────────────────────────────────
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateRequired(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? validateAlphaOnly(String fieldName, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return '$fieldName is required';
    }
    if (v.length > maxTextLength) {
      return '$fieldName must be at most $maxTextLength characters';
    }
    if (RegExp(r'[0-9]').hasMatch(v)) {
      return '$fieldName cannot contain numbers';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(v)) {
      return 'Enter a valid $fieldName';
    }
    return null;
  }

  static List<TextInputFormatter> get alphaOnly => [
    FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
    LengthLimitingTextInputFormatter(maxTextLength),
  ];


  static String? validateName(String? fieldName, String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length > maxTextLength) {
      return '$fieldName must be at most $maxTextLength characters';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
      return 'Enter a valid $fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (value.trim().length > maxTextLength) {
      return 'Email must be at most $maxTextLength characters';
    }
    final emailRegExp = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ── Password ──────────────────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Phone validator — only fires when Form.validate() is explicitly
  /// called (e.g. on "Next" / "Submit" tap), not on every keystroke.
  /// Pair this with `autovalidateMode: AutovalidateMode.disabled` on
  /// the PhoneFormField so a single digit doesn't trigger the error.
  static String? Function(PhoneNumber?) validatePhoneNumber(
      BuildContext context) {
    return PhoneValidator.compose([
      PhoneValidator.required(
        context,
        errorText: 'Phone number is required',
      ),
      PhoneValidator.validMobile(
        context,
        errorText: 'Enter a valid mobile number for this country',
      ),
    ]);
  }

  // ── Pincode / Postal Code ─────────────────────────────────
  /// Required, alphanumeric, 3–10 chars (supports international postal codes)
  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    final postalCode = value.trim();

    if (postalCode.length < 3) {
      return 'Min 3 characters';
    }
    if (postalCode.length > 10) {
      return 'Max 10 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s-]+$').hasMatch(postalCode)) {
      return 'Invalid postal code';
    }
    return null;
  }

  // ── NEET Score ────────────────────────────────────────────
  /// Mandatory, numeric only, range 0–720
  static String? validateNeetScore(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NEET score is required';
    }
    final score = int.tryParse(value.trim());
    if (score == null) {
      return 'Enter a valid numeric score';
    }
    if (score < minNeet || score > maxNeet) {
      return 'Score must be between $minNeet and $maxNeet';
    }
    return null;
  }

  // ── Dropdown / selection ──────────────────────────────────
  static String? validateDropdown<T>(String? fieldName, T? value) {
    if (value == null) {
      return 'Please select a $fieldName';
    }
    return null;
  }

  static List<TextInputFormatter> get digitsOnly => [
    FilteringTextInputFormatter.digitsOnly,
  ];

  /// Letters and spaces only — use on name fields
  static List<TextInputFormatter> get lettersOnly => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
    LengthLimitingTextInputFormatter(maxTextLength),
  ];

  /// General text with max 100 char limiter
  static List<TextInputFormatter> get textWithLimit => [
    LengthLimitingTextInputFormatter(maxTextLength),
  ];

  static List<TextInputFormatter> get postalCode => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s-]')),
    LengthLimitingTextInputFormatter(10),
  ];
}