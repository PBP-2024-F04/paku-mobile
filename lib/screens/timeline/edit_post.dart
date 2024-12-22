import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:paku/settings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditPostPage extends StatefulWidget {
  final Post post;

  const EditPostPage(this.post, {super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();

  String _text = "";

  @override
  void initState() {
    super.initState();
    _text = widget.post.text;
  }

  void _editPost(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "$apiURL/timeline/json/posts/${widget.post.id}/edit",
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
      appBar: AppBar(title: const Text("Edit a Post")),
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
                initialValue: _text,
                decoration: const InputDecoration(
                  hintText: "Apa yang ada di pikiranmu?",
                ),
                onChanged: (value) => setState(() => _text = value),
              ),
              ElevatedButton(
                onPressed: () => _editPost(context, request),
                child: const Text('Edit!'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
