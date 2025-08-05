import 'package:flutter/material.dart';

class AuthTheme {
  // Warna utama aplikasi
  static const Color primaryColor = Color(0xFF10B981);
  static const Color primaryDarkColor = Color(0xFF059669);
  static const Color accentColor = Color(0xFF34D399);

  // Warna untuk mobile
  static const Color mobileOverlayColor = Color(0xFF10B981);
  static const Color mobileOverlayDarkColor = Color(0xFF059669);

  // Warna untuk link
  static const Color linkColor = Color(0xFFEF4444);
  static const Color mobileLinkColor = Color(0xFFFCD34D);

  // Gradient untuk mobile background
  static const LinearGradient mobileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Border radius
  static const double borderRadius = 12.0;
  static const double buttonBorderRadius = 25.0;
  static const double logoBorderRadius = 32.0;

  // Padding
  static const EdgeInsets formPadding = EdgeInsets.all(24.0);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 16.0);

  // Shadow
  static const List<BoxShadow> formShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> logoShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  // Text styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleStyle = TextStyle(fontSize: 14);

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Input decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white.withOpacity(0.95),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: fieldPadding,
      suffixIcon: suffixIcon,
    );
  }

  // Button style
  static ButtonStyle getButtonStyle({required bool isMobile}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isMobile ? Colors.white.withOpacity(0.95) : primaryColor,
      foregroundColor: isMobile ? primaryColor : Colors.white,
      padding: buttonPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      elevation: 4,
    );
  }

  // Form container decoration
  static BoxDecoration getFormContainerDecoration({required bool isMobile}) {
    return BoxDecoration(
      color: isMobile ? Colors.white.withOpacity(0.95) : Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: formShadow,
    );
  }

  // Logo container decoration
  static BoxDecoration getLogoContainerDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(logoBorderRadius),
      boxShadow: logoShadow,
    );
  }

  // Get text color based on screen size
  static Color getTextColor(
    bool isMobile, {
    Color? mobileColor,
    Color? desktopColor,
  }) {
    if (isMobile) {
      return mobileColor ?? Colors.white;
    }
    return desktopColor ?? const Color(0xFF374151);
  }

  // Get subtitle color based on screen size
  static Color getSubtitleColor(bool isMobile) {
    return getTextColor(
      isMobile,
      mobileColor: Colors.grey[100],
      desktopColor: Colors.grey[500],
    );
  }

  // Get label color based on screen size
  static Color getLabelColor(bool isMobile) {
    return getTextColor(
      isMobile,
      mobileColor: Colors.white,
      desktopColor: Colors.grey[600],
    );
  }

  // Get link color based on screen size
  static Color getLinkColor(bool isMobile) {
    return isMobile ? mobileLinkColor : linkColor;
  }
}
