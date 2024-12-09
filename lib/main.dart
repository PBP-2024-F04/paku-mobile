import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/screens/accounts/home.dart';
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/landing.dart';
import 'package:paku/theme.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
