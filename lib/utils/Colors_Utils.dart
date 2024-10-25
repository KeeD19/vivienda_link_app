import 'package:flutter/material.dart';

class AppColors {
  static const Color orangeColor = Color(0xFFF16414); // Color principal
  static const Color bluePrimaryColor = Color(0xFF233BFF); // Fondo claro
  static const Color blueSecondColor = Color(0xFF439Ed5); // Color de acento
  static const Color backgroundColor = Color(0xFF001C43); // Color del texto

  static const MaterialColor customSwatch = MaterialColor(
    0xFF6200EE,
    <int, Color>{
      50: Color(0xFFE8EAF6),
      100: Color(0xFFC5CAE9),
      200: Color(0xFF9FA8DA),
      300: Color(0xFF7986CB),
      400: Color(0xFF5C6BC0),
      500: Color(0xFF3F51B5),
      600: Color(0xFF3949AB),
      700: Color(0xFF303F9F),
      800: Color(0xFF283593),
      900: Color(0xFF1A237E),
    },
  );
}
