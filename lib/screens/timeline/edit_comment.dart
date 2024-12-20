import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/models/comment.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditCommentPage extends StatefulWidget {
  final Comment comment;

  const EditCommentPage(this.comment, {super.key});

  @override
  State<EditCommentPage> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {
  final _formKey = GlobalKey<FormState>();

  String _text = "";

  void _editComment(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/timeline/json/comments/${widget.comment.id}/edit",
      jsonEncode({ 'text': _text }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'])),
          );

        Navigator.of(context).pop();
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
  void initState() {
    super.initState();
    _text = widget.comment.text;
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
                onPressed: () => _editComment(context, request),
                child: const Text('Edit!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
