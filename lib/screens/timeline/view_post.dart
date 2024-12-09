import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/models/comment.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/widgets/comment_card.dart';
import 'package:paku/screens/timeline/widgets/post_card.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage(this.post, {super.key});

  final Post post;

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  Future<List<Comment>> _fetchComments(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/timeline/json/posts/${widget.post.id}/show_comments');
    
    if (response is List<dynamic>) {
      return response.map((data) => Comment.fromJson(data)).toList();
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text("Post")),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              PostCard(widget.post),
              FutureBuilder(
                future: _fetchComments(request),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => CommentCard(snapshot.data[index]),
                    );
                  } else {
                    return Text(
                      'Belum ada komentar.',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
