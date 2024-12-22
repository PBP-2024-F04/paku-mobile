import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:paku/screens/favorites/edit_favorites.dart';
import 'package:paku/colors.dart';

class FavoritesByCategoryScreen extends StatelessWidget {
  final FCategory category;

  const FavoritesByCategoryScreen({Key? key, required this.category})
      : super(key: key);

  Future<List<Favorites>> fetchFavoritesByCategory(
      CookieRequest request, FCategory category) async {
    final url =
        'http://127.0.0.1:8000/favorites/category/${category.apiName}/json/';

    try {
      final response = await request.get(url);
      var data = response;

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

  Future<Product> fetchProductDetails(CookieRequest request, String productId) async {
    final url = 'http://127.0.0.1:8000/products/json/$productId/';

    try {
      final response = await request.get(url);
      var data = response;
      return Product.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.displayName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daftar Favorite per Kategori
            Expanded(
              child: FutureBuilder<List<Favorites>>(
                future: fetchFavoritesByCategory(
                    context.watch<CookieRequest>(), category),
                builder: (context, snapshot) {
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
                        return _buildFavoriteCard(context, favorite);
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

  Widget _buildFavoriteCard(BuildContext context, Favorites favorite) {
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
                      favorite.fields.product,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      favorite.fields.category.displayName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      favorite.fields.category.displayName,
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
                      // Ambil detail produk berdasarkan ID produk
                      final product = await fetchProductDetails(
                        context.watch<CookieRequest>(),
                        favorite.fields.product,
                      );

                      // Arahkan pengguna ke halaman EditFavoritePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditFavoritePage(
                            favorite: favorite,
                            product: product,
                          ),
                        ),
                      );
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
                      final response = await http.delete(
                        Uri.parse(
                            'http://127.0.0.1:8000/favorites/${favorite.pk}/delete'),
                      );

                      if (response.statusCode == 204) {
                        // Berhasil menghapus
                        print(
                            "Product ${favorite.fields.product} deleted successfully");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "${favorite.fields.product} has been deleted.")),
                        );
                      } else {
                        // Jika gagal menghapus
                        print(
                            "Failed to delete ${favorite.fields.product}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Failed to delete ${favorite.fields.product}")),
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
