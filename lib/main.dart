// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_asset_management/pages/user/login.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.purple[50],

        // Custome button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 30,
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Colors.purple,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
