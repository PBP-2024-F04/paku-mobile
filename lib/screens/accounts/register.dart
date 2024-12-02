import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/register_foodie.dart';
import 'package:paku/screens/accounts/register_merchant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("Register as Foodie"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterFoodiePage()),
                ),
              ),
              ElevatedButton(
                child: const Text("Register as Merchant"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterMerchantPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
