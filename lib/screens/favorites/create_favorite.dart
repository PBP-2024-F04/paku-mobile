import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paku/settings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/accounts/home.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:paku/screens/favorites/models/favorites.dart';
import 'package:paku/colors.dart'; 

class CreateFavoritePage extends StatefulWidget {
  final Product product;

  const CreateFavoritePage({super.key, required this.product});

  @override
  State<CreateFavoritePage> createState() => _CreateFavoritePageState();
}

class _CreateFavoritePageState extends State<CreateFavoritePage> {
  final _formKey = GlobalKey<FormState>();
  FCategory _category = FCategory.wantToTry;

  void _addFavorite(BuildContext context, CookieRequest request) async {
    final productId = widget.product.pk;

    final response = await request.postJson(
      "$apiURL/favorites/create_favorite_json/$productId/",
      jsonEncode(<String, dynamic>{
        'category': fCategoryValues.reverse[_category],
        'product_id': widget.product.pk,
      }),
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Favorite successfully added!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Favorites'),
        backgroundColor: TailwindColors.mossGreenDefault,
        foregroundColor: TailwindColors.whiteLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: TailwindColors.mossGreenLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TailwindColors.mossGreenDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add "${widget.product.fields.productName}" to Your Favorites',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TailwindColors.yellowDark,
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

                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.yellowActive,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryOption('Want to Try', FCategory.wantToTry),
                _buildCategoryOption('Loving It', FCategory.lovingIt),
                _buildCategoryOption('All Time Favorite', FCategory.allTimeFavorites),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        TailwindColors.redDefault,
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _addFavorite(context, request); 
                      }
                    },
                    child: const Text(
                      'Add to Favorites',
                      style: TextStyle(color: TailwindColors.whiteLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, 
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String title, FCategory category) {
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
          color: TailwindColors.yellowLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: TailwindColors.yellowDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Radio<FCategory>(
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
