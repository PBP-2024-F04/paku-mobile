import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/accounts/home.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/products/models/product.dart';

class CreateFavoritePage extends StatefulWidget {
  final Product product;

  const CreateFavoritePage({super.key, required this.product});

  @override
  State<CreateFavoritePage> createState() => _CreateFavoritePageState();
}

class _CreateFavoritePageState extends State<CreateFavoritePage> {
  final _formKey = GlobalKey<FormState>();
  String _category = "want_to_try";  // Default category

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add to Favorites',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[200], // Moss Green
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[800]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add "${widget.product.fields.productName}" to Your Favorites',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildProductDetails('Name', widget.product.fields.productName),
                  _buildProductDetails('Restaurant', widget.product.fields.restaurant),
                  _buildProductDetails('Price', 'Rp ${widget.product.fields.price}'),
                  _buildProductDetails('Description', widget.product.fields.description),
                  _buildProductDetails('Category', widget.product.fields.category),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Selection Section
            const Text(
              'Select Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoryOption('Want to Try', 'want_to_try'),
            _buildCategoryOption('Loving It', 'loving_it'),
            _buildCategoryOption('All Time Favorite', 'all_time_favorites'),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Send data to Django
                    final response = await request.postJson(
                      "http://127.0.0.1:8000/create_favorite_flutter/",
                      jsonEncode(<String, String>{
                        'category': _category,
                      }),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Favorite successfully added!"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("An error occurred. Please try again."),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  'Add to Favorites',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String title, String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _category = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow[700]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Radio<String>(
              value: category,
              groupValue: _category,
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
