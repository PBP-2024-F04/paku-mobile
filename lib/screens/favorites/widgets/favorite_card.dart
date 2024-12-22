import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/favorites/edit_favorites.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  final Favorites favorite;

  const FavoriteCard(this.favorite, {super.key});

  Future<Product> fetchProductDetails(CookieRequest request, String productId) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/products/json/$productId/');
      return Product.fromJson(response[0]);
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }

  Future<void> deleteFavorite(CookieRequest request, String favoriteId) async {
    final response = await request.postJson(
      "http://127.0.0.1:8000/favorites/$favoriteId/delete_favorite_json",
      "",
    );

    if (!response['success']) {
      throw Exception(response['message'] ?? "Failed to delete favorite.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return GestureDetector(
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.product,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      favorite.category.displayName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      favorite.category.displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: TailwindColors.mossGreenDefault),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final product = await fetchProductDetails(
                        request,
                        favorite.productId,
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditFavoritePage(
                              favorite: favorite,
                              product: product,
                            ),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: TailwindColors.yellowLight,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Edit"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final request = context.read<CookieRequest>();
                      await deleteFavorite(request, favorite.favorite);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Favorit berhasil dihapus."),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: TailwindColors.redDefault,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
