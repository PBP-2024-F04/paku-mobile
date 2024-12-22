import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paku/screens/products/models/product.dart';
import 'package:paku/screens/favorites/create_favorite.dart'; 
import 'package:paku/colors.dart';  

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Product>> products;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    products = fetchSearchResults(widget.query);
  }

  // Fetch data products berdasarkan query
  Future<List<Product>> fetchSearchResults(String query) async {
    final response = await http.get(Uri.parse('http://localhost:8000/favorites/favorites/search_flutter/?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results: "${widget.query}"'),
      ),
      body: Column(
        children: [
          // Search bar di bagian atas dengan tombol search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search again...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: TailwindColors.sageLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Memperbarui hasil pencarian berdasarkan query baru
                      products = fetchSearchResults(_searchController.text.trim());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TailwindColors.mossGreenDefault,  // Menggunakan backgroundColor, bukan primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text("Search"),
                ),
              ],
            ),
          ),

          // Menampilkan hasil pencarian produk
          Expanded(
            child: FutureBuilder<List<Product>>(
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
                            onPressed: () {
                              // Menggunakan Navigator untuk pergi ke CreateFavoritePage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateFavoritePage(product: product),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}