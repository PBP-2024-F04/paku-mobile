import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/view_post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewPostPage(post.id)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${post.user.displayName} @${post.user.username}"),
                Text(post.text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
