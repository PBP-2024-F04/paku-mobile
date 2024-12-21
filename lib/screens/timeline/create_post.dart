import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();

  String _text = "";

  void _createPost(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/timeline/json/posts/create",
      jsonEncode({ 'text': _text }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'])),
          );

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TimelineMainPage()),
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
      appBar: AppBar(title: const Text("Create a Post")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Apa yang ada di pikiranmu?",
                ),
                onChanged: (value) => setState(() => _text = value),
              ),
              ElevatedButton(
                onPressed: () => _createPost(context, request),
                child: const Text('Post!'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
