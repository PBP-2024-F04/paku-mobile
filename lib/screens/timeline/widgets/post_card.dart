import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/profile/profile.dart';
import 'package:paku/screens/timeline/edit_post.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:paku/screens/timeline/view_post.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard(this.post, {super.key});

  void _editPost(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostPage(post),
      ),
    );
  }

  void _deletePost(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        actions: [
          TextButton(
            child: const Text("Yes"),
            onPressed: () async {
              await request.postJson(
                "http://localhost:8000/timeline/json/posts/${post.id}/delete",
                "",
              );

              if (context.mounted) {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TimelineMainPage(),
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
                      Row(
                        children: [
                          if (post.user.role == "Merchant")
                            const Icon(LucideIcons.chefHat, size: 14, color: TailwindColors.peachDefault,)
                          else 
                            const Icon(LucideIcons.utensilsCrossed, size: 14, color: TailwindColors.peachDefault,),
                          const SizedBox(width: 2),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              post.user.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text("—"),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              "@${post.user.username}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: TailwindColors.peachDefault,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Text(post.text),
                      if (post.isEdited)
                        Text(
                          "edited",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: TailwindColors.peachDefault,
                          ),
                        )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16.0),
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: const Text('View'),
                              leading: const Icon(Icons.arrow_outward_outlined),
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPostPage(post),
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text('Profile'),
                              leading: const Icon(Icons.person_outlined),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(username: post.user.username),
                                ),
                              ),
                            ),
                            if (post.isMine) ...[
                              ListTile(
                                title: const Text('Edit'),
                                leading: const Icon(Icons.edit_outlined),
                                onTap: () => _editPost(context),
                              ),
                              ListTile(
                                title: const Text('Delete'),
                                leading: const Icon(Icons.delete_outlined),
                                onTap: () => _deletePost(context, request),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
