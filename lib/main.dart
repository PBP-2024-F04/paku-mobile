// lib/main.dart
import 'package:flutter/material.dart';
import 'package:paku/screens/landing.dart';
<<<<<<< HEAD
import 'package:paku/screens/reviews/reviews.dart';
=======
import 'package:paku/theme.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/products/add_product.dart';
>>>>>>> products

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaKu',
<<<<<<< HEAD
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ReviewPage(),
=======
      theme: theme,
      home: Products(),
>>>>>>> products
    );
  }
}
