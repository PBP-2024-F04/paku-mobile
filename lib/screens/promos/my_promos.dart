import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/promos/add_promos.dart';
import 'package:paku/screens/promos/models/promo.dart';
import 'package:paku/screens/promos/edit_promo_page.dart';
import 'package:paku/settings.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyPromos extends StatefulWidget {
  const MyPromos({super.key});

  @override
  State<MyPromos> createState() => _MyPromosState();
}

class _MyPromosState extends State<MyPromos> {
  Future<List<Promo>>? _future;

  Future<List<Promo>> _fetchPromos(CookieRequest request) async {
    final response = await request.get(
      '$apiURL/promos/my_promo_list_json/',
    );

    if (response is List<dynamic>) {
      return response.map<Promo>((json) => Promo.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> _deletePromo(
    BuildContext context,
    CookieRequest request,
    String promoId,
  ) async {
    try {
      final response = await request.post(
        '$apiURL/promos/delete_promo_json/$promoId/',
        {},
      );

      if (context.mounted) {
        if (response['success']) {
          setState(() {
            _future = _fetchPromos(request);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ?? 'Gagal menghapus promo')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting promo')),
        );
      }
    }
  }

  Widget _promoBuilder(
    BuildContext context,
    AsyncSnapshot<List<Promo>> snapshot,
  ) {
    final request = context.read<CookieRequest>();

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
          final promo = snapshot.data![index];
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: TailwindColors.whiteLight,
              shape: const RoundedRectangleBorder(
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
                      'Berlaku hingga: ${promo.batasPenggunaan != null ? DateFormat('dd-MM-yyyy').format(promo.batasPenggunaan!) : "Tidak ada batas"}',
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
                                builder: (context) =>
                                    EditPromoPage(promo: promo),
                              ),
                            ).then((_) {
                              // Refresh list after edit
                              setState(() {
                                _future = _fetchPromos(request);
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
                                title: const Text('Konfirmasi Hapus'),
                                content: const Text(
                                  'Apakah kamu yakin ingin menghapus promo ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deletePromo(context, request, promo.id);
                                    },
                                    child: const Text('Hapus'),
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
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error fetching promos: ${snapshot.error}'));
    }

    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    _future ??= _fetchPromos(request);

    return Scaffold(
      appBar: AppBar(title: const Text("PaKu")),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  MaterialPageRoute(builder: (context) => const AddPromoPage()),
                ).then((_) {
                  // Refresh list after adding promo
                  setState(() {
                    _future = _fetchPromos(request);
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TailwindColors.sageDefault,
              ),
              child: const Text(
                "Tambah Promo Baru",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            // Container with padding and border
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: TailwindColors.peachDarker,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: TailwindColors.peachDarkActive,
                      width: 16,
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _future = _fetchPromos(request);
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
