import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout(BuildContext context, CookieRequest request) async {
    final response = await request.logout("http://localhost:8000/accounts/auth/logout/");
    String message = response["message"];

    if (context.mounted) {
      if (response['success']) {
        String username = response["username"];
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("$message Sampai jumpa, $username.")),
          );

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context, request),
          child: const Text("Logout"),
        )
      ),
    );
  }
}
