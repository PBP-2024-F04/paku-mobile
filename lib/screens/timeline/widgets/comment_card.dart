import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
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
                      onTap: () {},
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: const Text('Delete'),
                      onTap: () {},
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
