import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paku/colors.dart';
import 'package:paku/screens/promos/add_promos.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'models/promo.dart'; // Import model Promo

class MyPromos extends StatefulWidget {
  @override
  _MyPromosState createState() => _MyPromosState();
}

class _MyPromosState extends State<MyPromos> {
  Future<List<Promo>> fetchPromos(CookieRequest request) async {
    try {
      final response = await request.get('http://10.0.2.2:8000/promos/my_promo_list_json/');

      print('Fetch Promos Response status: ${response.statusCode}');
      print('Fetch Promos Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Deserialize the response body to a list of Promo objects
        return promoFromJson(response.body);
      } else {
        throw Exception('Failed to load promos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching promos: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text("PaKu")),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "My Promos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.mossGreenDarker,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tambahkan promo menarik untuk menarik perhatian calon pelanggan!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPromoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.sageDefault,
              ),
              child: Text("Tambah Promo Baru", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Promo>>(
                future: fetchPromos(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching promos: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Belum ada promo yang kamu tambahkan!'));
                  } else {
                    final promos = snapshot.data!;
                    return ListView.builder(
                      itemCount: promos.length,
                      itemBuilder: (context, index) {
                        var promo = promos[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 16),
                          color: TailwindColors.whiteDefault,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "📌",
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: TailwindColors.redHover,
                                      ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  promo.promoTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: TailwindColors.mossGreenDarker,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  promo.promoDescription,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: TailwindColors.mossGreenDarker,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Berlaku hingga: ${promo.batasPenggunaan}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/update_promos',
                                          arguments: promo.id,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: TailwindColors.yellowDefault,
                                        foregroundColor: TailwindColors.whiteDefault,
                                      ),
                                      child: const Text('Edit'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: TailwindColors.redDefault,
                                        foregroundColor: TailwindColors.whiteDefault,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
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
      ),
    );
  }
}
