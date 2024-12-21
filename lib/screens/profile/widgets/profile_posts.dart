import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/widgets/post_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePostsPage extends StatefulWidget {
  final Profile profile;

  const ProfilePostsPage(this.profile, {super.key});

  @override
  State<ProfilePostsPage> createState() => _ProfilePostsPageState();
}

class _ProfilePostsPageState extends State<ProfilePostsPage> {
  Future<List<Post>> _fetchPosts(BuildContext context, CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/profile/json/${widget.profile.username}/posts',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Post.fromJson(data)).toList();
    }

    return [];
  }

  Widget _postsBuilder(
    BuildContext context,
    AsyncSnapshot<List<Post>> snapshot,
  ) {
    if (snapshot.hasData && snapshot.data is List) {
      if (snapshot.data!.isEmpty) {
        return const Text("Belum ada post.");
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) => PostCard(snapshot.data![index]),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
      future: _fetchPosts(context, request),
      builder: _postsBuilder,
    );
  }
}
