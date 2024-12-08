import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/models/comment.dart';
import 'package:paku/screens/timeline/widgets/comment_card.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

final dummyComments = [
  Comment.fromJson({
    "id": "b13fbfa1-06f7-47d8-aca5-c1a26c1fb813",
    "text": "test",
    "username": "testmerchant",
    "displayname": "Test",
    "user_role": "Merchant",
    "user_id": "3a2ee016-762a-4a1d-9074-c64b2bf9b77b",
    "is_edited": false
  }),
  Comment.fromJson({
    "id": "0eba2e2b-078e-4312-9ad7-57d850391712",
    "text": "test",
    "username": "testfoodie",
    "displayname": "h",
    "user_role": "Foodie",
    "user_id": "99f1ae53-f503-4588-a42d-f0e8d54c4484",
    "is_edited": false
  }),
  Comment.fromJson({
    "id": "f2d9edb4-abd1-4e7f-bb10-1428bdb1bc40",
    "text": "apa si",
    "username": "testmerchant",
    "displayname": "Test",
    "user_role": "Merchant",
    "user_id": "3a2ee016-762a-4a1d-9074-c64b2bf9b77b",
    "is_edited": false
  }),
];

class ViewPostPage extends StatefulWidget {
  const ViewPostPage(this.postId, {super.key});

  final String postId;
  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  Future<List<Comment>> _fetchComments(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/timeline/json/posts/${widget.postId}/show_comments');
    
    if (response is List<dynamic>) {
      return response.map((data) => Comment.fromJson(data)).toList();
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.postId)),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
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
