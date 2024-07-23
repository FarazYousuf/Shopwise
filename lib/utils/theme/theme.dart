import 'package:flutter/material.dart';
import 'package:shop_wise/utils/theme/custom_themes/appbar_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/chip_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/text_field_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/text_theme.dart';
import 'package:shop_wise/utils/theme/custom_themes/elevated_button_theme.dart';

class SAppTheme {
  SAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: STextTheme.lightTextTheme,
    chipTheme: SchipTheme.lightChipTheme,
    appBarTheme: SAppBartheme.lightAppBarTheme,
    checkboxTheme: SCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: SBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: SElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: STextFormFieldTheme.lightInputDecorationTheme
  );


  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: STextTheme.darkTextTheme,
    elevatedButtonTheme: SElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: STextFormFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.darkOutlinedButtonTheme,
    chipTheme: SchipTheme.darkChipTheme,
    appBarTheme: SAppBartheme.darkAppBarTheme,
    checkboxTheme: SCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: SBottomSheetTheme.darkBottomSheetTheme,
  );
}