import 'package:flutter/material.dart';

class Responsive {
  final BuildContext _context;

  Responsive(this._context);

  static Responsive of(BuildContext context) => Responsive(context);

  double get screenWidth => MediaQuery.of(_context).size.width;
  double get screenHeight => MediaQuery.of(_context).size.height;
  double get statusBarHeight => MediaQuery.of(_context).padding.top;
  double get bottomPadding => MediaQuery.of(_context).padding.bottom;

  // Device type
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;

  // Small phone
  bool get isSmallPhone => screenWidth < 360;
  bool get isMediumPhone => screenWidth >= 360 && screenWidth < 414;
  bool get isLargePhone => screenWidth >= 414;

  // Responsive font scale
  double get fontScale {
    if (isSmallPhone) return 0.85;
    if (isMediumPhone) return 0.95;
    if (isLargePhone && isMobile) return 1.0;
    if (isTablet) return 1.1;
    return 1.2;
  }

  // Responsive spacing
  double get spacingScale {
    if (isSmallPhone) return 0.8;
    if (isMediumPhone) return 0.9;
    return 1.0;
  }

  // Responsive font sizes
  double fontSize(double base) => base * fontScale;
  double spacing(double base) => base * spacingScale;

  // Width percentage
  double wp(double percent) => screenWidth * percent / 100;

  // Height percentage
  double hp(double percent) => screenHeight * percent / 100;

  // Responsive padding
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: isMobile ? 16 : 24,
    vertical: isMobile ? 12 : 16,
  );

  EdgeInsets get cardPadding => EdgeInsets.all(isMobile ? 12 : 16);

  // Grid columns
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  // College card columns
  int get collegeCardColumns {
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  // Responsive value based on breakpoint
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

// Extension for easy access
extension ResponsiveExt on BuildContext {
  Responsive get responsive => Responsive(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
}