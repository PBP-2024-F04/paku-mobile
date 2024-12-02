import 'package:flutter/material.dart';

class RegisterFoodiePage extends StatefulWidget {
  const RegisterFoodiePage({super.key});

  @override
  State<RegisterFoodiePage> createState() => _RegisterFoodiePageState();
}

class _RegisterFoodiePageState extends State<RegisterFoodiePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Register Foodie Page")),
    );
  }
}
