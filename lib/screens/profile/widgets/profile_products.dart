import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:paku/screens/products/product_detail_page.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/settings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfileProductsPage extends StatefulWidget {
  final Profile profile;

  const ProfileProductsPage(this.profile, {super.key});

  @override
  State<ProfileProductsPage> createState() => _ProfileProductsPageState();
}

class _ProfileProductsPageState extends State<ProfileProductsPage> {
  Future<List<Product>> _fetchProduct(BuildContext context, CookieRequest request) async {
    final response = await request.get(
      '$apiURL/profile/json/${widget.profile.username}/products',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Product.fromJson(data)).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 25),
              Expanded(
                child: FutureBuilder(
                  future: _fetchProduct(context, request),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data produk pada PaKu.',
                          style: TextStyle(
                            fontSize: 20,
                            color: TailwindColors.sageDarker,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      // Adjust grid layout based on screen width
                      int crossAxisCount =
                          constraints.maxWidth < 600 ? 1 : 2;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: constraints.maxWidth < 600 ? 1.2 : 0.8,
                        ),
                        itemCount: snapshot.data.length,
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
            ],
          ),
        );
      },
    );
  }
}
