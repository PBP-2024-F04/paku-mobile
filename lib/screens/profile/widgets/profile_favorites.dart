import 'package:flutter/material.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/screens/favorites/widgets/favorite_card.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/settings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfileFavoritesPage extends StatefulWidget {
  final Profile profile;

  const ProfileFavoritesPage(this.profile, {super.key});

  @override
  State<ProfileFavoritesPage> createState() => _ProfileFavoritesPageState();
}

class _ProfileFavoritesPageState extends State<ProfileFavoritesPage> {
  Future<List<Favorites>> _fetchFavorites(BuildContext context, CookieRequest request) async {
    final response = await request.get(
      '$apiURL/profile/json/${widget.profile.username}/favorites',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Favorites.fromJson(data)).toList();
    }

    return [];
  }

  Widget _favoritesBuilder(
    BuildContext context,
    AsyncSnapshot<List<Favorites>> snapshot,
  ) {
    if (snapshot.hasData && snapshot.data is List) {
      if (snapshot.data!.isEmpty) {
        return const Text("Belum ada favorites.");
      }
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final favorite = snapshot.data![index];
          return FavoriteCard(favorite);
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
      future: _fetchFavorites(context, request),
      builder: _favoritesBuilder,
    );
  }
}
