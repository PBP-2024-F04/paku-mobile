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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 40,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Username",
                    labelText: "Username",
                  ),
                  onChanged: (String? value) => setState(() => _username = value!),
                ),

                const SizedBox(height: 10),
        
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                  ),
                  obscureText: true,
                  onChanged: (String? value) => setState(() => _password1 = value!),
                ),

                const SizedBox(height: 10),
        
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Password Confirmation",
                    labelText: "Password Confirmation",
                  ),
                  obscureText: true,
                  onChanged: (String? value) => setState(() => _password2 = value!),
                ),

                const SizedBox(height: 10),
        
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Restaurant Name",
                    labelText: "Restaurant Name",
                  ),
                  onChanged: (String? value) => setState(() => _restaurantName = value!),
                ),

                const SizedBox(height: 10),
        
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
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    fixedSize: const Size(200, 40),
                  ),
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
