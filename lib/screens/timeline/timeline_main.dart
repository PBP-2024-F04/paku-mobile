import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/create_post.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/widgets/post_card.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class TimelineMainPage extends StatefulWidget {
  const TimelineMainPage({super.key});

  @override
  State<TimelineMainPage> createState() => _TimelineMainPageState();
}

class _TimelineMainPageState extends State<TimelineMainPage> {
  Future<List<Post>>? _future;
  String _query = "";

  Future<List<Post>> _fetchPosts(
    CookieRequest request, {
    String query = "",
  }) async {
    final response = await request.get(
      Uri.parse('http://localhost:8000/timeline/json/posts')
          .replace(queryParameters: {"query": query}).toString(),
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
    _future ??= _fetchPosts(request);

    return Scaffold(
      appBar: AppBar(title: const Text("Timeline")),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              SearchBar(
                hintText: 'Search...',
                elevation: const WidgetStatePropertyAll(0),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(
                      color: TailwindColors.mossGreenDark,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => setState(() => _query = value),
                trailing: [
                  IconButton(
                    onPressed: () => setState(() {
                      _future = _fetchPosts(request, query: _query);
                    }),
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              FutureBuilder(
                future: _future,
                builder: _postsBuilder,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TailwindColors.sageDark,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreatePostPage()),
        ),
        child: const Icon(Icons.draw),
      ),
    );
  }
}
