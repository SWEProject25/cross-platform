import 'package:flutter/material.dart';

/// Responsive utility class for adaptive UI across different screen sizes
class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  /// Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Check if device is in portrait mode
  bool get isPortrait => MediaQuery.of(context).orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  /// Responsive width based on percentage
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Responsive height based on percentage
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Get responsive font size
  double fontSize(double baseSize) {
    // Scale based on screen width (375 is base iPhone width)
    return baseSize * (screenWidth / 375);
  }

  /// Get responsive padding
  double padding(double basePadding) {
    return basePadding * (screenWidth / 375);
  }

  /// Check if device is small phone
  bool get isSmallPhone => screenWidth < 360;

  /// Check if device is medium phone
  bool get isMediumPhone => screenWidth >= 360 && screenWidth < 400;

  /// Check if device is large phone
  bool get isLargePhone => screenWidth >= 400 && screenWidth < 600;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 600;

  /// Get responsive image height for tweets
  double getTweetImageHeight() {
    if (isTablet) return 300;
    if (isLandscape) return screenHeight * 0.4;
    return 200;
  }

  /// Get responsive max width for tweet content
  double getMaxContentWidth() {
    if (isTablet) return 600;
    return screenWidth;
  }
}

/// Extension to easily access ResponsiveUtils from BuildContext
extension ResponsiveContext on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}
