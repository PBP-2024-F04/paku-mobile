import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:paku/screens/landing.dart';
<<<<<<< HEAD
import 'package:paku/screens/reviews/reviews.dart';
=======
import 'package:paku/theme.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/products/add_product.dart';
>>>>>>> products
=======
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/theme.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
>>>>>>> dev

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'PaKu',
        theme: theme,
        home: const LoginPage(),
      ),
>>>>>>> dev
    );
  }
}
