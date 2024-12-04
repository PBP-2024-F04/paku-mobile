import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Merchant"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Username",
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) => setState(() => _username = value!),
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
                onChanged: (String? value) => setState(() => _password1 = value!),
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password Confirmation",
                  labelText: "Password Confirmation",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
                onChanged: (String? value) => setState(() => _password2 = value!),
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Restaurant Name",
                  labelText: "Restaurant Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) => setState(() => _restaurantName = value!),
              ),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Register Merchant'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: $_username'),
                              Text('Password: $_password1'),
                              Text('Password Confirmation: $_password2'),
                              Text('Restaurant Name: $_restaurantName'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              _formKey.currentState?.reset();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Register Merchant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
