import 'package:flutter/material.dart';

class ViewProductsPage extends StatelessWidget {
  // Contoh data produk
  final List<Map<String, dynamic>> products = [
    {
      "productName": "Burger",
      "restaurant": "Burger Place",
      "price": 50000,
      "description": "Delicious beef burger with cheese",
      "category": "Fast Food",
    },
    {
      "productName": "Pizza",
      "restaurant": "Pizza House",
      "price": 75000,
      "description": "Large pizza with pepperoni topping",
      "category": "Italian",
    },
    {
      "productName": "Sushi",
      "restaurant": "Sushi World",
      "price": 100000,
      "description": "Fresh sushi with salmon and tuna",
      "category": "Japanese",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(product["productName"]),
              subtitle: Text("${product["restaurant"]} - ${product["category"]}"),
              trailing: Text("Rp ${product["price"]}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["productName"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product["productName"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Restaurant: ${product["restaurant"]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${product["category"]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: Rp ${product["price"]}",
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              product["description"],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}