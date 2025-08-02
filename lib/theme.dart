import 'package:flutter/material.dart';

class AppTheme {
  // static const Color primaryColor = Color.fromARGB(255, 108, 110, 255);
//  static const Color primaryColor = Color.fromARGB(255, 199, 38, 252);

  static const Color primaryColor = Color.fromARGB(255, 136, 30, 53);

  static const Color secondaryColor = Color(0xFF32CD32);

  static const Color backgroundColor = Color.fromARGB(255, 242, 243, 248);

  static const Color cardColor = Colors.white;

  static const Color textPrimaryColor = Color(0xFF203748);
  static const Color textSecondaryColor = Color(0xFF718096);

  static ThemeData get theme {
    return ThemeData(
      fontFamily: "Baloo2",
    );
  }
}
