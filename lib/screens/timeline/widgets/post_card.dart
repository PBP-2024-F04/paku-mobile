import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/edit_post.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/view_post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
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
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: const Text('Edit'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPostPage(post)),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
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
