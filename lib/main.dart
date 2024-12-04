// lib/main.dart
import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/register.dart';
import 'package:paku/screens/landing.dart';
import 'package:paku/colors.dart'; 
import 'package:google_fonts/google_fonts.dart';

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

        textTheme: TextTheme(
          // Body Texts
          bodyLarge: GoogleFonts.lato(color: TailwindColors.mossGreenDarker),  // bodyText1
          bodyMedium: GoogleFonts.lato(color: TailwindColors.mossGreenDarker), // bodyText2
          bodySmall: GoogleFonts.lato(color: TailwindColors.mossGreenDarker),  // bodyText3

          // Title Texts
          titleLarge: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800),  // headline1
          titleMedium: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800), // headline2
          titleSmall: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800,),  // headline3

          // Label Texts
          labelLarge: GoogleFonts.lato(color: TailwindColors.mossGreenDarker),  // subtitle1
          labelMedium: GoogleFonts.lato(color: TailwindColors.mossGreenDarker), // subtitle2
          labelSmall: GoogleFonts.lato(color: TailwindColors.mossGreenDarker),  // caption

          // Display Texts (for larger headers)
          displayLarge: GoogleFonts.lato(color: TailwindColors.mossGreenDarker), // display1
          displayMedium: GoogleFonts.lato(color: TailwindColors.mossGreenDarker), // display2
          displaySmall: GoogleFonts.lato(color: TailwindColors.mossGreenDarker), // display3
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),

        // Menentukan font (opsional)
        // fontFamily: 'YourFontFamily',
      ),
      home: const RegisterPage(),
    );
  }
}
