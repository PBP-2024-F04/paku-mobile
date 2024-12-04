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
              Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "Buat akun PaKu dan mulai jelajahi Kuliner Palu!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterFoodiePage()),
                ),
                child: const Text("Buat akun Foodie"),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterMerchantPage()),
                ),
                child: const Text("Buat akun Merchant"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
