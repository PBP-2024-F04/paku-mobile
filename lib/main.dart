// lib/main.dart
import 'package:flutter/material.dart';
import 'package:paku/screens/landing.dart';
import 'package:paku/screens/promos/promos.dart';
import 'package:paku/colors.dart'; // Import colors.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaKu',
      theme: ThemeData(
        useMaterial3: true,

        // Mengatur skema warna utama menggunakan ColorScheme
        colorScheme: const ColorScheme(
          primary: TailwindColors.sageDark,
          primaryContainer: TailwindColors.yellowLight, // Material 3 uses primaryContainer
          secondary: TailwindColors.peachDefault,
          secondaryContainer: TailwindColors.peachLight,
          surface: Colors.white,
          error: TailwindColors.redDefault,
          onPrimary: TailwindColors.mossGreenDarker, // Warna teks di atas warna primary
          onSecondary: Colors.white,
          onSurface: TailwindColors.mossGreenDarker,
          onError: Colors.white,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: TailwindColors.yellowLight,

        textTheme: const TextTheme(
          // Body Texts
          bodyLarge: TextStyle(color: TailwindColors.mossGreenDarker),  // bodyText1
          bodyMedium: TextStyle(color: TailwindColors.mossGreenDarker), // bodyText2
          bodySmall: TextStyle(color: TailwindColors.mossGreenDarker),  // bodyText3

          // Title Texts
          titleLarge: TextStyle(color: TailwindColors.mossGreenDarker),  // headline1
          titleMedium: TextStyle(color: TailwindColors.mossGreenDarker), // headline2
          titleSmall: TextStyle(color: TailwindColors.mossGreenDarker),  // headline3

          // Label Texts
          labelLarge: TextStyle(color: TailwindColors.mossGreenDarker),  // subtitle1
          labelMedium: TextStyle(color: TailwindColors.mossGreenDarker), // subtitle2
          labelSmall: TextStyle(color: TailwindColors.mossGreenDarker),  // caption

          // Display Texts (for larger headers)
          displayLarge: TextStyle(color: TailwindColors.mossGreenDarker), // display1
          displayMedium: TextStyle(color: TailwindColors.mossGreenDarker), // display2
          displaySmall: TextStyle(color: TailwindColors.mossGreenDarker), // display3

          // Menentukan font (opsional)
          // fontFamily: 'YourFontFamily',
        ),

        // Menentukan font (opsional)
        // fontFamily: 'YourFontFamily',
      ),
      home: const LandingPage(),
    );
  }
}
