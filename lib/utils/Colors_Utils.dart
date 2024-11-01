import 'package:flutter/material.dart';

class AppColors {
  static const Color orangeColor = Color(0xFFF16414);
  static const Color bluePrimaryColor = Color(0xFF233BFF);
  static const Color blueSecondColor = Color(0xFF439Ed5);
  static const Color backgroundColor = Color(0xFF001C43);
  static const Color successColor = Color(0xFF32f31f);
  // static const Color pendingColor = Color(0xFF001C43);
  static const Color errorColor = Color(0xFFE12020);
  static const Color primary = Color(0xff10AA4D);
  static const Color primary2 = Color(0xff70F2A1);
  static const Color heading = Color(0xff1E1E1E);
  static const Color activeBlack = Color(0xff272727);
  static const Color text = Color(0xff545454);
  static Color lightText = const Color(0xff828282).withOpacity(0.15);
  static const Color white = Color(0xffffffff);

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
