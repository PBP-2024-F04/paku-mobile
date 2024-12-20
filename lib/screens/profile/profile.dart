import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/profile/widgets/profile_favorites.dart';
import 'package:paku/screens/profile/widgets/profile_posts.dart';
import 'package:paku/screens/profile/widgets/profile_products.dart';
import 'package:paku/screens/profile/widgets/profile_reviews.dart';

class ProfilePage extends StatelessWidget {
  final status = "Foodie";

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: status == "Foodie" ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          bottom: TabBar(
            labelColor: TailwindColors.whiteLight,
            unselectedLabelColor: TailwindColors.whiteLight,
            tabs: status == "Foodie"
                ? (const [
                    Tab(icon: Icon(Icons.description)),
                    Tab(icon: Icon(Icons.reviews)),
                    Tab(icon: Icon(Icons.star)),
                  ])
                : (const [
                    Tab(icon: Icon(Icons.description)),
                    Tab(icon: Icon(Icons.shopping_cart)),
                  ]),
          ),
        ),
        body: TabBarView(
          children: status == "Foodie"
              ? (const [
                  ProfilePostsPage(),
                  ProfileReviewsPage(),
                  ProfileFavoritesPage(),
                ])
              : (const [
                  ProfilePostsPage(),
                  ProfileProductsPage(),
                ]),
        ),
      ),
    );
  }
}
