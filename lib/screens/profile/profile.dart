import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/profile/widgets/profile_favorites.dart';
import 'package:paku/screens/profile/widgets/profile_posts.dart';
import 'package:paku/screens/profile/widgets/profile_reviews.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          bottom: const TabBar(
            labelColor: TailwindColors.whiteLight,
            unselectedLabelColor: TailwindColors.whiteLight,
            tabs: [
              Tab(icon: Icon(Icons.description)),
              Tab(icon: Icon(Icons.reviews)),
              Tab(icon: Icon(Icons.star)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfilePostsPage(),
            ProfileReviewsPage(),
            ProfileFavoritesPage(),
          ],
        ),
      ),
    );
  }
}
