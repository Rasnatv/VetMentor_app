import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Single source of truth for the Privacy Policy URL so it's never
/// duplicated (and drifted) across screens.
final Uri privacyPolicyUrl = Uri.parse('http://vetmentor.co.in/privacy-policy');

/// Opens the Privacy Policy link in the device's external browser.
/// Shared by ProfileScreen (View Profile / Profile Details) and
/// UpdateProfileScreen so tapping "Privacy Policy" anywhere in the
/// app behaves identically — it never opens an in-app page, only
/// the live link above.
Future<void> openPrivacyPolicy(BuildContext context) async {
  final launched = await launchUrl(
    privacyPolicyUrl,
    mode: LaunchMode.externalApplication,
  );
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Could not open the Privacy Policy page.'),
      ),
    );
  }
}