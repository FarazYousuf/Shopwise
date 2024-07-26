import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:shop_wise/utils/theme/theme.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: SAppTheme.lightTheme,
        darkTheme: SAppTheme.darkTheme,
        home: App(), 
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system,
//       theme: SAppTheme.lightTheme,
//       darkTheme: SAppTheme.darkTheme,
//       home: MultiProvider(providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ], child: App()),
//     );
//   }
// }
