import 'package:flutter/material.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage(this.postId, {super.key});

  final String postId;

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postId),
      ),
    );
  }
}
