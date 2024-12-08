import 'dart:convert';

import 'package:flutter/material.dart';
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
      "http://localhost:8000/accounts/auth/register/merchant/",
      jsonEncode({
        "username": _username,
        "password1": _password1,
        "password2": _password2,
        "restaurant_name": _restaurantName,
      }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text(
                  "Create Merchant Account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 30),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
