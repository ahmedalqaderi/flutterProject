import 'package:flutter/material.dart';
import 'package:talabiapp/util/app_constants.dart';

ThemeData light({Color color = const Color.fromARGB(255, 0, 74, 97)}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: Color.fromARGB(255, 244, 144, 32),
   shadowColor:  const Color(0xFF009f67),
 

  disabledColor: const Color.fromARGB(255, 0, 74, 97),
  brightness: Brightness.light,
  hintColor: const Color.fromARGB(255, 0, 74, 97),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(/*foregroundColor: color*/)),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)),
);