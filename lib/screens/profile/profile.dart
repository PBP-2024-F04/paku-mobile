import 'package:flutter/material.dart';
import 'package:paku/screens/profile/widgets/profile_favorites.dart';
import 'package:paku/screens/profile/widgets/profile_posts.dart';
import 'package:paku/screens/profile/widgets/profile_products.dart';
import 'package:paku/screens/profile/widgets/profile_reviews.dart';
import 'package:paku/widgets/left_drawer.dart';

class ProfilePage extends StatelessWidget {
  final status = "Merchant";

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: status == "Foodie" ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("h's Profile"),
        ),
        drawer: const LeftDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 10.0),
            Text("h", style: Theme.of(context).textTheme.displayMedium),
            Text("@testfoodie", style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10.0),
            TabBar(
              labelStyle: Theme.of(context).textTheme.bodySmall,
              tabs: status == "Foodie"
                  ? (const [
                      Tab(icon: Icon(Icons.description_outlined), text: "Posts"),
                      Tab(icon: Icon(Icons.reviews_outlined), text: "Reviews"),
                      Tab(icon: Icon(Icons.star_outline), text: "Favorites"),
                    ])
                  : (const [
                      Tab(icon: Icon(Icons.description_outlined), text: "Posts"),
                      Tab(icon: Icon(Icons.shopping_cart_outlined), text: "Products"),
                    ]),
            ),
            Expanded(
              child: TabBarView(
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
          ],
        ),
      ),
    );
  }
}
