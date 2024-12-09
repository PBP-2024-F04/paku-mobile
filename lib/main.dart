// lib/main.dart
import 'package:flutter/material.dart';
import 'package:paku/screens/landing.dart';
import 'package:paku/theme.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/products/add_product.dart';

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
      home: Products(),
    );
  }
}
