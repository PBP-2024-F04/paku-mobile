// lib/main.dart
import 'package:flutter/material.dart';
// import 'package:paku/screens/landing.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:paku/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaKu',
      theme: theme,
      home: const TimelineMainPage(),
    );
  }
}
