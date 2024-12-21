import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:paku/screens/products/models/product.dart';
import 'dart:convert';
import 'package:paku/colors.dart';

class EditFavoriteScreen extends StatefulWidget {
  final String favoriteId;  // Menambahkan ID favorit
  final String currentCategory;

  const EditFavoriteScreen({
    Key? key,
    required this.favoriteId,
    required this.currentCategory,
  }) : super(key: key);

  @override
  State<EditFavoriteScreen> createState() => _EditFavoriteScreenState();
}

class _EditFavoriteScreenState extends State<EditFavoriteScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.currentCategory;
  }

  // Fungsi untuk mengupdate kategori favorit
  Future<void> _updateFavorite(CookieRequest request) async {
    if (selectedCategory != null) {
      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/favorites/${widget.favoriteId}/edit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'category': selectedCategory}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product updated in favorites'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update favorite'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a category to update the product'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Favorite'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Menampilkan detail favorit
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Category: ${widget.currentCategory}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Pilih kategori favorit baru
            Text(
              'Select New Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCategoryOption('Want to Try', 'want_to_try'),
            _buildCategoryOption('Loving It', 'loving_it'),
            _buildCategoryOption('All Time Favorite', 'all_time_favorites'),
            SizedBox(height: 20),

            // Tombol untuk memperbarui kategori favorit
            ElevatedButton(
              onPressed: () => _updateFavorite(request),
              child: Text('Update Favorite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.redDefault,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(label),
        subtitle: Text('$value Products'),
        trailing: Radio<String>(
          value: value,
          groupValue: selectedCategory,
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },
        ),
      ),
    );
  }
}
