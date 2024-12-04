import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paku/colors.dart';

var theme = ThemeData(
  useMaterial3: true,

  colorScheme: const ColorScheme(
    primary: TailwindColors.sageDark,
    primaryContainer: TailwindColors.yellowLight,
    secondary: TailwindColors.peachDefault,
    secondaryContainer: TailwindColors.peachLight,
    surface: Colors.white,
    error: TailwindColors.redDefault,
    onPrimary: TailwindColors.mossGreenDarker,
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
    displayLarge: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800), // display1
    displayMedium: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800), // display2
    displaySmall: GoogleFonts.playfairDisplay(color: TailwindColors.mossGreenDarker, fontWeight: FontWeight.w800), // display3
  ),

  inputDecorationTheme: InputDecorationTheme(
    hintStyle: GoogleFonts.lato(color: TailwindColors.mossGreenDarker),
    border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: TailwindColors.sageDark,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: TailwindColors.sageDark,
    foregroundColor: Colors.white,
  ),
);
