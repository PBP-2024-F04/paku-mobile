import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/promos/promos.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:paku/screens/products/my_products.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:paku/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/widgets/left_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?> _fetchUserRole(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://localhost:8000/profile/json/',
      );

      if (response != null && response["role"] != null) {
        return response["role"];
      } else {
        throw Exception('Role not found in response');
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<String?>(
        future: _fetchUserRole(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                'Terjadi kesalahan saat memuat data. Coba lagi nanti.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            String userRole = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                children: userRole == 'Merchant'
                    ? _buildMerchantContent(context)
                    : _buildFoodieContent(context),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildMerchantContent(BuildContext context) {
    return [
      Text(
        "Palu Kuliner",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: TailwindColors.sageDarker, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        "Nikmati berbagai kuliner terbaik di Palu dan jelajahi menu favoritmu",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: TailwindColors.sageDark,
            ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      _buildCard(
        context,
        icon: const Icon(Icons.food_bank_outlined, size: 30, color: Colors.white),
        title: "My Products",
        description:
            "Tambahkan produk baru ke database Paku Kuliner dan biarkan pelanggan menjelajahi menu istimewa Anda!",
        cardColor: TailwindColors.sageDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyProductsPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.home_outlined, size: 30, color: Colors.white),
        title: "Timeline",
        description:
            "Jangan ketinggalan! Cari tahu apa yang sedang menjadi perbincangan penikmat kuliner di daerah Palu!",
        cardColor: TailwindColors.peachDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TimelineMainPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.discount_outlined, size: 30, color: Colors.white),
        title: "Reviews",
        description:
            "Tingkatkan produkmu dengan mendengar ulasan pelanggan tentang kuliner yang ada di Palu!",
        cardColor: TailwindColors.mossGreenDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReviewPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.book_outlined, size: 30, color: Colors.white),
        title: "My Promos",
        description:
            "Tambahkan informasi promo terbaru dan tarik lebih banyak pelanggan dengan penawaran menarik!",
        cardColor: TailwindColors.redDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyPromos()),
          );
        },
      ),
    ];
  }

  List<Widget> _buildFoodieContent(BuildContext context) {
    return [
      Text(
        "Palu Kuliner",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: TailwindColors.sageDarker, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        "Nikmati berbagai kuliner terbaik di Palu dan jelajahi menu favoritmu",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: TailwindColors.sageDark,
            ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      _buildCard(
        context,
        icon: const Icon(Icons.food_bank_outlined, size: 30, color: Colors.white),
        title: "Products",
        description:
            "Jelajahi beragam produk kuliner khas Palu yang menggugah selera—temukan makanan favorit Anda hari ini!",
        cardColor: TailwindColors.sageDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductsPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.home_outlined, size: 30, color: Colors.white),
        title: "Timeline",
        description:
            "Gabung dalam obrolan kuliner! Tanyakan, diskusikan, dan berbagi pengalaman dengan sesama pencinta makanan di Paku Kuliner.",
        cardColor: TailwindColors.peachDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TimelineMainPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.discount_outlined, size: 30, color: Colors.white),
        title: "Reviews",
        description:
            "Bagikan pengalaman Anda! Berikan ulasan dan rating pada produk yang Anda coba, bantu orang lain menemukan kuliner terbaik.",
        cardColor: TailwindColors.mossGreenDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReviewPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.star_border, size: 30, color: Colors.white),
        title: "Favorites",
        description:
            "Tandai produk favorit Anda! Gunakan label untuk menyimpan memori dan memudahkan pencarian kuliner berikutnya.",
        cardColor: TailwindColors.yellowDark, 
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReviewPage()),
          );
        },
      ),
      _buildCard(
        context,
        icon: const Icon(Icons.book_outlined, size: 30, color: Colors.white),
        title: "Promos",
        description:
            "Jangan lewatkan! Cek promo menarik dari restoran lokal dan nikmati hidangan lezat dengan harga spesial.",
        cardColor: TailwindColors.redDark,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Promos()),
          );
        },
      ),
    ];
  }

  Widget _buildCard(BuildContext context,
      {required Widget icon,
      required String title,
      required String description,
      required Color cardColor,
      required VoidCallback onPressed}) {
    return Card(
      color: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, 
      ),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}