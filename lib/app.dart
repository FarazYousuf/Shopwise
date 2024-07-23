import 'package:flutter/material.dart';
import 'package:shop_wise/features/screens/login_screen.dart';
import 'package:shop_wise/features/screens/main_screen.dart';
import 'package:shop_wise/features/screens/splash_screen.dart';
import 'package:shop_wise/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: SAppTheme.lightTheme,
      darkTheme: SAppTheme.darkTheme,
      home: SplashScreen(),  
    );
    
  
  }
}