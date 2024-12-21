import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/screens/profile/widgets/profile_favorites.dart';
import 'package:paku/screens/profile/widgets/profile_posts.dart';
import 'package:paku/screens/profile/widgets/profile_products.dart';
import 'package:paku/screens/profile/widgets/profile_reviews.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? username;

  const ProfilePage({this.username, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String status = "Foodie";

  Future<Profile> _future(BuildContext context, CookieRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    final result = await request.get("http://localhost:8000/profile/json");
    return Profile.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
      future: _future(context, request),
      builder: _profile,
    );
  }

  Widget _profile(context, AsyncSnapshot<Profile> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: snapshot.hasData
          ? Text("${snapshot.data!.displayName}'s Profile")
          : const Text("Profile"),
      ),
      drawer: const LeftDrawer(),
      body: _tabs(context, snapshot),
    );
  }

  Widget _tabs(context, AsyncSnapshot<Profile> snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: status == "Foodie" ? 3 : 2,
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Text(snapshot.data!.displayName, style: Theme.of(context).textTheme.displayMedium),
          Text("@${snapshot.data!.username}", style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10.0),
          TabBar(
            labelStyle: Theme.of(context).textTheme.bodySmall,
            tabs: snapshot.data!.role == "Foodie"
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
              children: snapshot.data!.role == "Foodie"
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
    );
  }
}
