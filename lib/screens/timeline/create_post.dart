import 'package:flutter/material.dart';
import 'package:paku/screens/timeline/timeline_main.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a Post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Apa yang ada di pikiranmu?",
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TimelineMainPage()),
              ),
              child: const Text('Post!'),
            ),
          ],
        ),
      )
    );
  }
}
