import 'package:flutter/material.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/screens/favorites/widgets/favorite_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FavoritesByCategoryScreen extends StatelessWidget {
  final FCategory category;

  const FavoritesByCategoryScreen({super.key, required this.category});

  Future<List<Favorites>> fetchFavoritesByCategory(CookieRequest request, FCategory category) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/favorites/category/${category.apiName}/json/',
      );

      final data = response;

      List<Favorites> favoritesList = [];
      for (var d in data['favorites']) {
        if (d != null) {
          favoritesList.add(Favorites.fromJson(d));
        }
      }

      return favoritesList;
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(category.displayName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Favorites>>(
                future: fetchFavoritesByCategory(request, category),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada kuliner pada kategori favorit ini.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
