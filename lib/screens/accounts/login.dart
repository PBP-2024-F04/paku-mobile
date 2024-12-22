import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paku/screens/accounts/home.dart';
import 'package:paku/screens/accounts/register.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password = "";

  void _login(BuildContext context, CookieRequest request) async {
    final response = await request.login("http://localhost:8000/accounts/auth/login/", {
      'username': _username,
      'password': _password,
    });

    if (request.loggedIn) {
      String message = response['message'];
      String username = response['username'];
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("$message Selamat datang, $username.")));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Gagal'),
            content: Text(response['message']),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                  const Icon(LucideIcons.logIn, size: 50),
                  Text(
                    "Sign in to PaKu",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Name",
                      labelText: "Name",
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
                        setState(() => _password = value!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _login(context, request),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage())
                    ),
                    child: const Text("Belum punya akun? Registrasi!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
