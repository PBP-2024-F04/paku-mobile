import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/models/comment.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/widgets/comment_card.dart';
import 'package:paku/screens/timeline/widgets/post_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage(this.post, {super.key});

  final Post post;

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  final _formKey = GlobalKey<FormState>();

  String _comment = "";

  void _createComment(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/timeline/json/posts/${widget.post.id}/create_comment",
      jsonEncode({ 'text': _comment }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'])),
          );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ViewPostPage(widget.post)),
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

  Future<List<Comment>> _fetchComments(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/timeline/json/posts/${widget.post.id}/show_comments',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Comment.fromJson(data)).toList();
    }

    return [];
  }

  Widget _commentsBuilder(
    BuildContext context,
    AsyncSnapshot<List<Comment>> snapshot,
  ) {
    if (snapshot.hasData && snapshot.data is List) {
      if (snapshot.data!.isEmpty) {
        return const Text("Belum ada komentar.");
      }
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => CommentCard(snapshot.data![index]),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text("Post")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                PostCard(widget.post),
                FutureBuilder(
                  future: _fetchComments(request),
                  builder: _commentsBuilder,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Berikan komentarmu!",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => setState(() => _comment = value),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _createComment(context, request),
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
