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
  Future<List<Post>> _fetchPosts(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/timeline/json/posts');
    
    if (response is List<dynamic>) {
      return response.map((data) => Post.fromJson(data)).toList();
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
                trailing: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              FutureBuilder(
                future: _fetchPosts(request),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => PostCard(snapshot.data[index]),
                    );
                  } else {
                    return Text(
                      'Belum ada post.',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }
                },
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
