import 'package:flutter/material.dart';

import '../core/style/textstyle.dart';
class FieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  const FieldWrapper({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }}