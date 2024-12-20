import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/promos/add_promos.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'dart:convert';
import 'package:paku/screens/promos/models/promo.dart';
import 'package:paku/screens/promos/edit_promo_page.dart';

class MyPromos extends StatefulWidget {
  @override
  _MyPromosState createState() => _MyPromosState();
}

class _MyPromosState extends State<MyPromos> {
  Future<List<Promo>>? _future;

  // Function to fetch the list of promos
  Future<List<Promo>> fetchPromos(CookieRequest request) async {
    try {
      // Ensure the URL is correct
      final response = await request.get('http://localhost:8000/promos/my_promo_list_json/');

      print('Fetch Promos Response: $response');

      // Assuming response is List<dynamic>
      return response.map<Promo>((json) => Promo.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching promos: $e');
      return [];
    }
  }

  // Function to delete a promo
  Future<void> deletePromo(CookieRequest request, String promoId) async {
    try {
      final response = await request.post(
        'http://localhost:8000/promos/delete_promo_json/$promoId/',
        {}, // No additional data needed
      );

      if (response['success']) {
        // Successfully deleted, refresh promo list
        setState(() {
          _future = fetchPromos(request);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Gagal menghapus promo')),
        );
      }
    } catch (e) {
      print('Error deleting promo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting promo')),
      );
    }
  }

  // Function to build the promo list widget
  Widget _promoBuilder(BuildContext context, AsyncSnapshot<List<Promo>> snapshot) {
    final request = context.read<CookieRequest>(); // Access request from context

    if (snapshot.hasData && snapshot.data is List) {
      if (snapshot.data!.isEmpty) {
        return const Center(
          child: Text(
            "Belum ada promo yang kamu tambahkan.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          var promo = snapshot.data![index];
          return Container(
            width: double.infinity, // Fill container width
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: TailwindColors.whiteLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
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
                      promo.batasPenggunaan != null
                          ? 'Berlaku hingga: ${DateFormat('dd-MM-yyyy').format(promo.batasPenggunaan!)}'
                          : 'Berlaku hingga: Tidak Ada Batas',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Edit Button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPromoPage(promo: promo),
                              ),
                            ).then((_) {
                              // Refresh list after edit
                              setState(() {
                                _future = fetchPromos(request);
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: TailwindColors.yellowDefault,
                            foregroundColor: TailwindColors.whiteDefault,
                          ),
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        // Delete Button with confirmation
                        TextButton(
                          onPressed: () {
                            // Confirm before deleting
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text('Apakah kamu yakin ingin menghapus promo ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deletePromo(request, promo.id);
                                    },
                                    child: Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
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
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Center(child: Text('Error fetching promos: ${snapshot.error}'));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    _future ??= fetchPromos(request);

    return Scaffold(
      appBar: AppBar(title: const Text("PaKu")),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title text "My Promos"
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
                ).then((_) {
                  // Refresh list after adding promo
                  setState(() {
                    _future = fetchPromos(request);
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.sageDefault,
              ),
              child: Text("Tambah Promo Baru", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            // Container with padding and border
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0), // Padding around container
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: TailwindColors.peachDarker, // Container background color
                    borderRadius: BorderRadius.zero, // No rounded corners
                    border: Border.all(
                      color: TailwindColors.peachDarkActive, // Border color
                      width: 16, // Border width
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _future = fetchPromos(request);
                      });
                    },
                    child: FutureBuilder<List<Promo>>(
                      future: _future,
                      builder: _promoBuilder,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
