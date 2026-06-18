
import 'package:flutter/services.dart';

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

  // ── Phone number ──────────────────────────────────────────
  /// Exactly 10 digits, no letters or symbols
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^\d{10}$');
    // if (!phoneRegExp.hasMatch(value.trim())) {
    //   return 'Enter a valid 10-digit phone number';
    // }
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
  /// Digits only — use on phone & NEET fields
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