import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/edit_comment.dart';
import 'package:paku/screens/timeline/models/comment.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/view_post.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final Post post;

  const CommentCard(this.comment, this.post, {super.key});

  void _editComment(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditCommentPage(comment),
      ),
    );

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ViewPostPage(post),
        )
      );
    }
  }

  void _deleteComment(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        actions: [
          TextButton(
            child: const Text("Yes"),
            onPressed: () async {
              await request.postJson(
                "http://localhost:8000/timeline/json/comments/${comment.id}/delete",
                "",
              );

              if (context.mounted) {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ViewPostPage(post),
                    ),
                  );
              }
            },
          ),
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
            color: TailwindColors.mossGreenDark,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.text),
                  ],
                ),
              ),
              if (comment.isMine)
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: const Text('Edit'),
                      onTap: () => _editComment(context),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: const Text('Delete'),
                      onTap: () => _deleteComment(context, request),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
