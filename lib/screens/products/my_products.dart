import 'package:paku/colors.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/products/add_product.dart';
import 'package:paku/screens/products/edit_product.dart';
import 'package:paku/screens/reviews/product_review.dart';
import 'package:paku/screens/products/models/product.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  late Future<List<Product>> _products;

  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get("http://localhost:8000/products/my-products-flutter");

    List<Product> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }

    return listProduct;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

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
              child: FutureBuilder<List<Product>>(
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
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: TailwindColors.whiteLightActive,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: TailwindColors.whiteActive,
                                      blurRadius: 15.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: SizedBox(
                                        height: 180,
                                        width: double.infinity,
                                        child: product.fields.productImage != null
                                            ? Image.network(
                                                product.fields.productImage!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(Icons.image_not_supported),
                                                  );
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(child: CircularProgressIndicator());
                                                },
                                              )
                                            : const Center(child: Icon(Icons.image_not_supported)),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            product.fields.productName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            product.fields.description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: TailwindColors.whiteDarker,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  product.fields.category,
                                                  style: const TextStyle(
                                                    color: TailwindColors.peachDefault,
                                                    fontSize: 12,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "Rp ${product.fields.price}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: TailwindColors.peachDarker,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                            builder: (context) => EditProductPage(
                                              productId: product.pk,
                                              initialData: product,
                                            ),
                                          ),
                                        ).then((_) => refreshProducts());
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: TailwindColors.redDefault),
                                      onPressed: () async {
                                        try {
                                          final request = context.read<CookieRequest>();
                                          await deleteProduct(request, product.pk);
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

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

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
                const SizedBox(height: 20),
                if (product.fields.productImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      product.fields.productImage!,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        product.fields.productName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "Rp ${product.fields.price}",
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
                      product.fields.category,
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
                  product.fields.description,
                  style: _grayText(),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Restaurant",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  product.fields.restaurant,
                  style: _grayText(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductReviewPage(productId: product.pk),
            ),
          );
        },
        backgroundColor: TailwindColors.yellowDefault,
        label: const Text(
          'Lihat Review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.visibility),
      ),
    );
  }

  TextStyle _grayText() => const TextStyle(color: TailwindColors.whiteDark, fontSize: 15);
}
