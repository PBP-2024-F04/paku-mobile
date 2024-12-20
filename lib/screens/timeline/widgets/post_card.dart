import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/edit_post.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:paku/screens/timeline/view_post.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewPostPage(post)),
          );
        },
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.displayName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        "@${post.user.username}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(post.text),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'View',
                      child: const Text('View'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPostPage(post)),
                      ),
                    ),
                    ...(post.isMine
                        ? [
                            PopupMenuItem<String>(
                              value: 'Edit',
                              child: const Text('Edit'),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPostPage(post)),
                              ),
                            ),
                            PopupMenuItem<String>(
                                value: 'Delete',
                                child: const Text('Delete'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Are you sure?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            request.postJson(
                                                "http://localhost:8000/timeline/json/posts/${post.id}/delete",
                                                "");
                                            Navigator.of(context)
                                              ..pop()
                                              ..pushReplacement(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TimelineMainPage()));
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
                                }),
                          ]
                        : []),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
