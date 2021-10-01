import 'package:flutter/material.dart';

class RideColors {

  static const MaterialColor primaryColor = MaterialColor(0xFF38B6FF, <int, Color>{
    50: Color(0xFFEBF8FF),
    100: Color(0x1A1F1D1C),
    200: Color(0x331F1D1C),
    300: Color(0x4D1F1D1C),
    400: Color(0x661F1D1C),
    500: Color(0x801F1D1C),
    600: Color(0x991F1D1C),
    700: Color(0xB31F1D1C),
    800: Color(0xCC1F1D1C),
    900: Color(0xE61F1D1C),
  });

  // Figma's project uses Grey12, Grey24..... but the hexa was FFFFFF so we chose to call them white.
  static const MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{
    12: Color(0xFF1F1D1C),
    24: Color(0xFF3D3C3C),
    40: Color(0xFF666362),
    64: Color(0xFFA39F9D),
    88: Color(0xFFE0DFDE),
    96: Color(0xFFF5F5F5),
    98: Color(0xFFFAFAFA),
  });

  static const MaterialColor black = MaterialColor(0xFF000000, <int, Color>{
    08: Color(0x141F1D1C),
  });

  static const MaterialColor backgroundGrey = MaterialColor(0xFF09090A, <int, Color>{
    64: Color(0x09090A),
  });

  static const MaterialColor orange = MaterialColor(0xFFF25D07, <int, Color>{
    50: Color(0xFFFEF2EB),
  });

  static const MaterialColor green = MaterialColor(0xFF009E55, <int, Color>{
    50: Color(0xFF009E55),
  });
}

final ThemeData appThemeData = ThemeData(
    primarySwatch: RideColors.primaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Aileron',
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: RideColors.white[12],
        fontFamily: 'Aileron',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      bodyText2: TextStyle(
        color: RideColors.white[12],
        fontFamily: 'Aileron',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      headline1: TextStyle(
        color: RideColors.white,
        fontFamily: 'Courier Prime',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      ),
      headline3: TextStyle(
        color: RideColors.white,
        fontFamily: 'Aileron',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      ),
      headline4: TextStyle(
        color: RideColors.white[12],
        fontFamily: 'Aileron',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      ),
      headline5: TextStyle(
        color: RideColors.white,
        fontFamily: 'Aileron',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      ),
      headline6: TextStyle(
        color: RideColors.white[12],
        fontFamily: 'Aileron',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      ),
    ));
