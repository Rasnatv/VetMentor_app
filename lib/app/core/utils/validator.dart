//
// import 'package:flutter/services.dart';
//
// class DValidator {
//   /// Max character limit for all text fields
//   static const int maxTextLength = 100;
//
//   /// NEET score range
//   static const int minNeet = 0;
//   static const int maxNeet = 720;
//
//   // ── Generic empty check ───────────────────────────────────
//   static String? validateEmptyText(String? fieldName, String? value) {
//     if (value == null || value.isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
//
//   // ── Name (first / last) ───────────────────────────────────
//   /// Max 100 chars, letters and spaces only
//   static String? validateName(String? fieldName, String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     if (value.trim().length > maxTextLength) {
//       return '$fieldName must be at most $maxTextLength characters';
//     }
//     if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
//       return 'Enter a valid $fieldName';
//     }
//     return null;
//   }
//
//   // ── Email ─────────────────────────────────────────────────
//   /// Required, valid format, max 100 chars
//   static String? validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     if (value.trim().length > maxTextLength) {
//       return 'Email must be at most $maxTextLength characters';
//     }
//     final emailRegExp = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]+$');
//     if (!emailRegExp.hasMatch(value.trim())) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }
//
//   // ── Password ──────────────────────────────────────────────
//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters long';
//     }
//     if (!value.contains(RegExp(r'[A-Z]'))) {
//       return 'Password must contain at least one uppercase letter';
//     }
//     if (!value.contains(RegExp(r'[0-9]'))) {
//       return 'Password must contain at least one number';
//     }
//     if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}<>]'))) {
//       return 'Password must contain at least one special character';
//     }
//     return null;
//   }
//
//   // ── Phone number ──────────────────────────────────────────
//   /// Exactly 10 digits, no letters or symbols
//   static String? validatePhoneNumber(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Phone number is required';
//     }
//     final phoneRegExp = RegExp(r'^\d{10}$');
//     // if (!phoneRegExp.hasMatch(value.trim())) {
//     //   return 'Enter a valid 10-digit phone number';
//     // }
//     return null;
//   }
//
//   // ── NEET Score ────────────────────────────────────────────
//   /// Mandatory, numeric only, range 0–720
//   static String? validateNeetScore(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'NEET score is required';
//     }
//     final score = int.tryParse(value.trim());
//     if (score == null) {
//       return 'Enter a valid numeric score';
//     }
//     if (score < minNeet || score > maxNeet) {
//       return 'Score must be between $minNeet and $maxNeet';
//     }
//     return null;
//   }
//
//   // ── Dropdown / selection ──────────────────────────────────
//   static String? validateDropdown<T>(String? fieldName, T? value) {
//     if (value == null) {
//       return 'Please select a $fieldName';
//     }
//     return null;
//   }
//
//   // ── Input formatters (reusable) ───────────────────────────
//   /// Digits only — use on phone & NEET fields
//   static List<TextInputFormatter> get digitsOnly => [
//     FilteringTextInputFormatter.digitsOnly,
//   ];
//
//   /// Letters and spaces only — use on name fields
//   static List<TextInputFormatter> get lettersOnly => [
//     FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
//     LengthLimitingTextInputFormatter(maxTextLength),
//   ];
//
//   /// General text with max 100 char limiter
//   static List<TextInputFormatter> get textWithLimit => [
//     LengthLimitingTextInputFormatter(maxTextLength),
//   ];
// }
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_form_field/phone_form_field.dart';

class DValidator {
  /// Max character limit for all text fields
  static const int maxTextLength = 100;

  /// NEET score range
  static const int minNeet = 0;
  static const int maxNeet = 720;

  // ── Generic empty check ───────────────────────────────────
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Generic required field ─────────────────────────────────
  /// Use for plain "Required" fields (state, district, country, address)
  /// where you don't need a custom field name in the message.
  static String? validateRequired(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  // ── Name (first / last) ───────────────────────────────────
  /// Max 100 chars, letters and spaces only
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

  // ── Email ─────────────────────────────────────────────────
  /// Required, valid format, max 100 chars
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

  // ── Phone number (country-code aware) ──────────────────────
  /// Validates a [PhoneNumber] (from phone_form_field) against the
  /// libphonenumber rules for whichever country is currently selected
  /// in the PhoneController. Required + must be a valid mobile number
  /// for that country — no fixed digit-length assumption, since the
  /// correct length varies by country code (India = 10, others differ).
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

  // ── Pincode ───────────────────────────────────────────────
  /// Required, must have at least [length] digits (default 6 for India).
  static String? validatePincode(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (value.trim().length < length) return '$length digits needed';
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

  // ── Input formatters (reusable) ───────────────────────────
  /// Digits only — use on NEET & pincode fields.
  /// NOTE: phone number is NOT formatted here — PhoneFormField
  /// (from phone_form_field) handles its own digit limiting per
  /// country via shouldLimitLengthByCountry, since allowed length
  /// varies by country code.
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
}