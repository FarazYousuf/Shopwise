import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_wise/features/screens/login_screen.dart';
import 'package:shop_wise/features/screens/main_screen.dart';
import 'package:shop_wise/features/screens/splash_screen.dart';
// import 'package:shop_wise/utils/theme/theme.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<AuthProvider>(context).user;
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user != null) {
          return MainScreen();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}