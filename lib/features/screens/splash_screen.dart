import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_wise/features/screens/login_screen.dart';
import 'package:shop_wise/features/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
  with SingleTickerProviderStateMixin{

    @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
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
              end: Alignment.bottomRight
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Shopwise',
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




































// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_wise/features/authentication/providers/auth_providers.dart';
// import 'main_screen.dart';
// import 'login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 3), () {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       if (authProvider.user != null) {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
//       } else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.blue,
//         child: Center(
//           child: Image.asset('assets/logo/bird_2.jpg'),
//         ),
//       ),
//     );
//   }
// }
