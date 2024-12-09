import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/products/add_product.dart';

class Products extends StatelessWidget {
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
        centerTitle: true,
        backgroundColor: TailwindColors.sageDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.sageDarkHover,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/${product['category'].toLowerCase()}.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product["productName"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product["restaurant"],
                                style: const TextStyle(color: TailwindColors.whiteDark),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                "Rp ${product["price"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: TailwindColors.sageDarkHover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
        backgroundColor: TailwindColors.sageDark,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: AssetImage("assets/images/${product['category'].toLowerCase()}.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product["productName"],
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Restaurant: ${product["restaurant"]}",
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: TailwindColors.whiteDark),
              ),
              const SizedBox(height: 8),
              Text(
                "Category: ${product["category"]}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                "Price: Rp ${product["price"]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TailwindColors.sageDarkHover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Description:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product["description"],
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}