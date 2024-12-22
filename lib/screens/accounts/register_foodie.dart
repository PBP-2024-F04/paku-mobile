import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// username, password1, password2, full_name

class RegisterFoodiePage extends StatefulWidget {
  const RegisterFoodiePage({super.key});

  @override
  State<RegisterFoodiePage> createState() => _RegisterFoodiePageState();
}

class _RegisterFoodiePageState extends State<RegisterFoodiePage> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password1 = "";
  String _password2 = "";
  String _fullName = "";

  void _registerFoodie(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/accounts/auth/register/foodie/",
      jsonEncode({
        "username": _username,
        "password1": _password1,
        "password2": _password2,
        "full_name": _fullName,
      }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'])),
          );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Failed to register!')),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Foodie"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.utensilsCrossed, size: 50),
                  Text(
                    "Create Foodie Account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Username",
                      labelText: "Username",
                    ),
                    onChanged: (String? value) =>
                        setState(() => _username = value!),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onChanged: (String? value) =>
                        setState(() => _password1 = value!),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password Confirmation",
                      labelText: "Password Confirmation",
                    ),
                    obscureText: true,
                    onChanged: (String? value) =>
                        setState(() => _password2 = value!),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Full Name",
                      labelText: "Full Name",
                    ),
                    onChanged: (String? value) =>
                        setState(() => _fullName = value!),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () => _registerFoodie(context, request),
                    style:
                        ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                    child: const Text('Register Foodie'),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
