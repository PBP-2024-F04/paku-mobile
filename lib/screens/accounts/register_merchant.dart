import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/settings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// username, password1, password2, restaurant_name

class RegisterMerchantPage extends StatefulWidget {
  const RegisterMerchantPage({super.key});

  @override
  State<RegisterMerchantPage> createState() => _RegisterMerchantPageState();
}

class _RegisterMerchantPageState extends State<RegisterMerchantPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password1 = "";
  String _password2 = "";
  String _restaurantName = "";

  void _registerMerchant(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "$apiURL/accounts/auth/register/merchant/",
      jsonEncode({
        "username": _username,
        "password1": _password1,
        "password2": _password2,
        "restaurant_name": _restaurantName,
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
        title: const Text("Register Merchant"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Icon(LucideIcons.chefHat, size: 50),
                  Text(
                    "Create Merchant Account",
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
                      hintText: "Restaurant Name",
                      labelText: "Restaurant Name",
                    ),
                    onChanged: (String? value) =>
                        setState(() => _restaurantName = value!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _registerMerchant(context, request),
                    style:
                        ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                    child: const Text('Register Merchant'),
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
