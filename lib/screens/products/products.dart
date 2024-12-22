import 'package:paku/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:paku/screens/reviews/product_review.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<Product>> fetchProduct(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/products/json/');
    
    var data = response;
    
    List<Product> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaKu'),
      ),
      drawer: const LeftDrawer(),
      body: Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            const Text(
              "All Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchProduct(request),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return const Column(
                      children: [
                        Text(
                          'Belum ada data produk pada PaKu.',
                          style: TextStyle(fontSize: 20, color: TailwindColors.sageDarker),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: snapshot.data[index],
                              ),
                            ),
                          ),
                          child: ProductCard(product: snapshot.data[index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ]
        )
      )
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Stack(
              children: [
                ClipRRect(
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: product.fields.productImage != null
                        ? Image.network(
                            product.fields.productImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.image_not_supported));
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
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            color: TailwindColors.whiteLightActive,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.fields.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  product.fields.restaurant,
                  style: const TextStyle(
                    fontSize: 14,
                    color: TailwindColors.whiteDarker,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product.fields.category,
                      style: const TextStyle(
                        color: TailwindColors.peachDefault,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Rp ${product.fields.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TailwindColors.peachDarker,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;

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
                const SizedBox(
                  height: 3,
                ),
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
                    const Icon(
                      Icons.favorite,
                      size: 28,
                      color: TailwindColors.redDefault,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: widget.product.fields.productImage != null
                          ? Image.network(
                              widget.product.fields.productImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.product.fields.productName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "Rp ${widget.product.fields.price}",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant,
                      color: TailwindColors.yellowDefault,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.product.fields.restaurant,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
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
                      widget.product.fields.category,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
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
                  widget.product.fields.description,
                  style: _grayText(),
                ),
                const SizedBox(height: 15),
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
              builder: (context) => ProductReviewPage(productId: widget.product.pk.toString()),
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
