
import 'package:flutter/material.dart';

class SDeviceUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // static Future<void> setStatusBarColor(Color color) async {
  //   SystemChrome.setSystemUiOverlayStyle(
  //     SystemUiOverlayStyle(setStatusBarColor: color),
  //     );
  // }
}