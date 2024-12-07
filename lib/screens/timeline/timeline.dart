import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/timeline/models/post.dart';
import 'package:paku/screens/timeline/widgets/post.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
      ),
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
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dummyData.length,
                itemBuilder: (context, index) => PostWidget(dummyData[index]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TailwindColors.sageDark,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.draw),
      ),
    );
  }

  var dummyData = [
    Post.fromJson({
      "id": "1c5e6d6e-a302-40c1-b70c-6d66d5ebe8c0",
      "user": {
        "role": "Merchant",
        "display_name": "Test",
        "username": "testmerchant"
      },
      "text": "asdf",
      "is_edited": false,
      "created_at": "2024-10-27T08:17:53.424Z",
      "updated_at": "2024-10-27T08:17:53.424Z"
    }),
    Post.fromJson({
      "id": "fcc6bb7e-25c0-44e3-98b0-41982fe45ab1",
      "user": {
        "role": "Foodie",
        "display_name": "123456789012345678901234567890",
        "username": "testfoodie123"
      },
      "text": "Hello, World!",
      "is_edited": false,
      "created_at": "2024-10-27T04:12:26.175Z",
      "updated_at": "2024-10-27T04:12:26.175Z"
    }),
    Post.fromJson({
      "id": "932c5407-f2b5-49f4-b36f-844f75481e26",
      "user": {"role": "Foodie", "display_name": "h", "username": "testfoodie"},
      "text": "testsfdsfsdf",
      "is_edited": true,
      "created_at": "2024-10-27T03:40:22.018Z",
      "updated_at": "2024-10-27T03:44:40.796Z"
    }),
    Post.fromJson({
      "id": "788dfdf7-d8cb-45a1-ad1a-a78d6e4404bc",
      "user": {"role": "Foodie", "display_name": "h", "username": "testfoodie"},
      "text": "hello2",
      "is_edited": false,
      "created_at": "2024-10-27T03:39:24.107Z",
      "updated_at": "2024-10-27T03:39:24.107Z"
    }),
    Post.fromJson({
      "id": "5b5e9e8e-c22e-49ff-b33c-7d6554f2acf5",
      "user": {"role": "Foodie", "display_name": "h", "username": "testfoodie"},
      "text": "hello1",
      "is_edited": false,
      "created_at": "2024-10-27T03:39:13.465Z",
      "updated_at": "2024-10-27T03:39:13.465Z"
    }),
  ];
}
