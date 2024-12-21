import 'package:paku/colors.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/products/add_product.dart';
import 'package:paku/screens/products/edit_product.dart';
import 'package:paku/screens/reviews/product_review.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  late Future<List<dynamic>> _products;

  Future<List<dynamic>> fetchProducts(CookieRequest request) async {
    final response = await request.get("http://localhost:8000/products/my-products-flutter/");
    if (response['success']) {
      return response['products'];
    } else {
      throw Exception(response['message'] ?? "Failed to fetch products.");
    }
  }

  Future<void> deleteProduct(CookieRequest request, String productId) async {
    final response = await request.post(
      "http://localhost:8000/products/me/$productId/delete-product/",
      {},
    );

    if (response['status'] == 'success') {
      return;
    } else {
      throw Exception(response['message'] ?? "Failed to delete product.");
    }
  }

  void refreshProducts() {
    setState(() {
      _products = fetchProducts(context.read<CookieRequest>());
    });
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _products = fetchProducts(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            const Text(
              "My Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductPage(),
                  ),
                ).then((_) => refreshProducts());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.sageDark,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Tambah Produk Baru",
                style: TextStyle(
                  color: TailwindColors.whiteLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: TailwindColors.redDefault),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Anda belum memiliki produk. Silakan tambahkan produk baru."),
                    );
                  } else {
                    final products = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        product: product,
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: TailwindColors.whiteLight,
                                          boxShadow: [
                                            BoxShadow(
                                              color: TailwindColors.whiteActive,
                                              blurRadius: 15.0,
                                              spreadRadius: 0.5,
                                              offset: Offset(3.0, 3.0),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                child: SizedBox(
                                                  height: 120,
                                                  width: MediaQuery.of(context).size.width,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                product['product_name'],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                child: Text(
                                                  product['description'],
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: TailwindColors.whiteDark,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    product['category'],
                                                    style: const TextStyle(
                                                      color: TailwindColors.peachDefault,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Rp ${product['price']}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: TailwindColors.yellowDefault),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProductPage(
                                                          productId: product['id'],
                                                          initialData: product,
                                                        )
                                                  ),
                                                ).then((_) => refreshProducts());
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: TailwindColors.redDefault),
                                              onPressed: () async {
                                                try {
                                                  final request = context.read<CookieRequest>();
                                                  await deleteProduct(request, product['id']);
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Produk berhasil dihapus."),
                                                      ),
                                                    );
                                                  }
                                                  refreshProducts();
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("Error: $e")),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
}

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.product['product_name'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "Rp ${widget.product['price']}",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.category,
                      color: TailwindColors.whiteDarkActive,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.product['category'] ?? 'No Category',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.product['description'] ?? 'No Description',
                  style: _grayText(),
                ),
                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductReviewPage(
                          productId: widget.product['id'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TailwindColors.mossGreenDefault,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "See Reviews",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  TextStyle _grayText() => const TextStyle(color: TailwindColors.whiteDark, fontSize: 15);
}
