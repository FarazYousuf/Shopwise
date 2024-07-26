import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_wise/features/screens/login_screen.dart';
import 'package:shop_wise/features/screens/main_screen.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }


  //  void initState() {
  //   super.initState();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  //   _checkAuthStatus();
  // }

  // Future<void> _checkAuthStatus() async {
  //   await Future.delayed(Duration(seconds: 3));
    
  //   // Check if the widget is still mounted
  //   if (!mounted) return;

  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   if (authProvider.user != null) {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
  //   } else {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  //   }
  // }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 116, 145, 117)],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Shopwise',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
