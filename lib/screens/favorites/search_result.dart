import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paku/screens/products/models/product.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchSearchResults(widget.query);
  }

  // Fetch data products berdasarkan query
  Future<List<Product>> fetchSearchResults(String query) async {
    final response = await http.get(Uri.parse('http://localhost:8000/favorites/search_flutter/?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  // Fungsi untuk menambahkan ke favorit
  Future<void> addToFavorites(String productId) async {
    final response = await http.post(
      Uri.parse('http://<your-server-ip>:8000/favorites/favorites/create-ajax/$productId'),
      body: {'category': 'want_to_try'}, // Kategori favorit
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Favorites')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add to favorites')));
      }
    } else {
      throw Exception('Failed to add to favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results: "${widget.query}"'),
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            final productList = snapshot.data!;
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product.fields.productName),
                    subtitle: Text('Rp ${product.fields.price}'),
                    leading: product.fields.user != null
                        ? CircleAvatar(child: Text(product.fields.user![0]))
                        : null,  // Menambahkan avatar jika ada user
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => addToFavorites(product.pk),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
