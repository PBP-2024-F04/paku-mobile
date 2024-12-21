import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;  // Pastikan ini ada

class FavoritesByCategoryScreen extends StatelessWidget {
  final String categoryName;

  const FavoritesByCategoryScreen({Key? key, required this.categoryName}) : super(key: key);

  Future<List<Favorites>> fetchFavoritesByCategory(CookieRequest request, String categoryName) async {
    String url;

    if (categoryName == 'want_to_try') {
      url = 'http://127.0.0.1:8000/favorites/category/wtt/json/';
    } else if (categoryName == 'loving_it') {
      url = 'http://127.0.0.1:8000/favorites/category/li/json/';
    } else if (categoryName == 'all_time_favorites') {
      url = 'http://127.0.0.1:8000/favorites/category/atf/json/';
    } else {
      throw Exception('Invalid category name');
    }

    print("yo");

    try {
      print("hai");
      final response = await request.get(url);

      print("object");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),  
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Tambah Kuliner Baru...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.green[50],
              ),
            ),
            SizedBox(height: 16),

            // Daftar Favorite per Kategori
            Expanded(
              child: FutureBuilder<List<Favorites>>(
                future: fetchFavoritesByCategory(context.watch<CookieRequest>(), categoryName),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(favorite.fields.category, style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    Text(
                      favorite.fields.category, 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      print("Navigate to Edit screen for ${favorite.fields.product}");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow[200],
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Edit"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final response = await http.delete(
                        Uri.parse('http://127.0.0.1:8000/favorites/${favorite.pk}/delete'),
                      );

                      if (response.statusCode == 204) {
                        // Berhasil menghapus
                        print("Product ${favorite.fields.product} deleted successfully");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${favorite.fields.product} has been deleted.")),
                        );
                      } else {
                        // Jika gagal menghapus
                        print("Failed to delete ${favorite.fields.product}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to delete ${favorite.fields.product}")),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Delete"),
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
