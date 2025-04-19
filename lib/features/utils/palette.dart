import 'package:flutter/material.dart';

class Palette {
    static final Color  primaryColor = Color(0xff6948FE);
    
  /// app basic colors
  static const Color primary = Color(0xff4b68ff);
  static const Color secondary = Color(0xffffe24b);
  static const Color accent = Color(0xffb0c7ff);

  /// Gradient colors
  static const Gradient linearGradient = LinearGradient(
      end: Alignment(0.707, -0.707),
      begin: Alignment(0, 0),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c4),
      ]
  );

  /// Text colors
  static const Color textPrimary = Color(0xff333333);
  static const Color textSecondary = Color(0xff6c757d);
  static const Color textWhite = Colors.white;

  /// Background colors
  static const Color light = Color(0xfff6f6f6);
  // static const Color light2 = Color(0xfffc0fc0);
  // static const Color light = Color(0xfffffff);
  // static const Color light3 = Color(0xff01b1e0);

  static const Color dark = Color(0xff272727);
  // static const Color dark = Color(0xfff400a1);
  // static const Color dark2 = Color(0xff00a8cc);
  // static const Color dark3 = Color(0xffffc300);
  static const Color primaryBackground = Color(0xfff3f5ff);

  /// Background Container colors
  static const Color lightContainer = Color(0xfff6f6f6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

  /// Button colors
  static const Color buttonPrimary = Color(0xff4b68ff);
  static const Color buttonSecondary = Color(0xff6c757d);
  static const Color buttonDisabled = Color(0xffc4c4c4);
  static const Color buttonColors = Color(0xffffffff);

  /// Border colors
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xffe6e6e6);

  /// Error and Validation colors
  static const Color error = Color(0xffd32f2f);
  static const Color success = Color(0xff388e3c);
  static const Color warning = Color(0xfff57c00);
  static const Color info = Color(0xff1976d2);

  /// Neutral Shades
  static const Color black = Color(0xff232323);
  static const Color darkerGrey = Color(0xff4f4f4f);
  static const Color darkGrey = Color(0xff939393);
  static const Color grey = Color(0xffe0e0e0);
  static const Color softGrey = Color(0xfff4f4f4);
  static const Color lightGrey = Color(0xfff9f9f9);
  static const Color white = Color(0xffffffff);
}
