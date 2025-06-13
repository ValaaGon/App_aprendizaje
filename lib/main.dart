import 'package:app_tesis/Pages/Login/login.dart';
import 'package:app_tesis/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF545979),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF545979),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFcea0aa),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
