import 'package:flutter/material.dart';
import 'package:paku/screens/landing.dart';
import 'package:paku/screens/reviews/reviews.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ReviewPage(),
    );
  }
}
