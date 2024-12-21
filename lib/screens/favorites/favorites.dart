import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/favorites/category_favorites.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/favorites/search_result.dart';
import 'package:paku/screens/accounts/login.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {'title': 'Want to Try', 'category': 'want_to_try'},
    {'title': 'Loving It', 'category': 'loving_it'},
    {'title': 'All Time Favorite', 'category': 'all_time_favorites'},
  ];

  // Fungsi untuk menangani pencarian
  void _searchProducts() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final request = context.watch<CookieRequest>();
      if (!request.loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), 
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(query: query),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    print(request.cookies);

    if (!request.loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Ganti dengan halaman login Anda
      );
      return const SizedBox(); 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Favorites",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Pencarian Kuliner Baru
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tambah Kuliner Baru...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.green[50],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Pencarian
            ElevatedButton(
              onPressed: _searchProducts,  // Menekan tombol untuk melakukan pencarian
              child: const Text("Search"),
            ),

            const SizedBox(height: 20),

            // Kategori Favorit
            const Text(
              "Categories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Menampilkan Kategori Favorit
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Arahkan ke halaman category favorites sesuai kategori yang dipilih
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesByCategoryScreen(
                            categoryName: category['category']!,
                          ),
                        ),
                      );
                    },
                    child: CategoryCard(
                      title: category['title']!,
                      category: category['category']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String category;

  const CategoryCard({super.key, required this.title, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
