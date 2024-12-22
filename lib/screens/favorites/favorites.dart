import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/favorites/category_favorites.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/colors.dart';  

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<FCategory> categories = [
    FCategory.wantToTry,
    FCategory.lovingIt,
    FCategory.allTimeFavorites,
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (!request.loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), 
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

            const Text(
              "Categories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,  
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesByCategoryScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: CategoryCard(
                      title: category.displayName,
                      category: category.apiName,
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
      color: TailwindColors.yellowLightActive,  
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Ukuran font lebih kecil
              textAlign: TextAlign.center,  // Agar teks tidak meluber
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
