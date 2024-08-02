import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:shop_wise/utils/theme/theme.dart';
import 'package:shop_wise/features/screens/scan_history.dart';
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
        theme: SAppTheme.lightTheme.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.grey.shade600,
            selectionColor: Colors.grey.withOpacity(0.6),
            selectionHandleColor: Colors.grey.shade700,
          ),
        ),
        darkTheme: SAppTheme.darkTheme.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.grey.withOpacity(0.6),
            selectionHandleColor: Colors.grey.shade500,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => App(),
          '/scanHistory': (context) => ScanHistoryScreen(),
          // '/locationPicker': (context) => LocationPickerScreen(),
          // '/productDetails': (context) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
