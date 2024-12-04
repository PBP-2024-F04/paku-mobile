import 'package:flutter/material.dart';
import 'package:paku/colors.dart'; // Import colors.dart untuk menggunakan TailwindColors

class Promos extends StatelessWidget {
  // Placeholder data untuk promo
  final List<Map<String, dynamic>> promos = [
    {
      'promo_title': 'Diskon 50% untuk Pembelian Pertama',
      'promo_description': 'Dapatkan diskon hingga 50% pada pembelian pertama.',
      'batas_penggunaan': '31 Desember 2024',
      'id': 1
    },
    {
      'promo_title': 'Gratis Ongkir!',
      'promo_description': 'Nikmati gratis ongkir untuk semua produk!',
      'batas_penggunaan': null,
      'id': 2
    },
    {
      'promo_title': 'Potongan 20% untuk Pembelian Kedua',
      'promo_description': 'Dapatkan potongan 20% pada pembelian kedua produk.',
      'batas_penggunaan': '15 Januari 2025',
      'id': 3
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Promo",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: TailwindColors.mossGreenDarker,
              ),
        ),
        backgroundColor: TailwindColors.sageDark,
      ),
      body: promos.isEmpty
          ? const Center(
              child: Text(
                'Belum ada promo yang kamu tambahkan!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.only(left: 64.0, right: 64.0, top: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                  color: TailwindColors.peachDarker, // Warna latar belakang container
                  borderRadius: BorderRadius.zero, // Tidak ada rounded corners
                  border: Border.all(
                    color: TailwindColors.peachDarkActive, // Warna border
                    width: 16, // Lebar border
                  ),
                ),
                child: ListView.builder(
                  itemCount: promos.length,
                  itemBuilder: (context, index) {
                    var promo = promos[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white, // Set card color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Set border radius to zero for sharp edges
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centering vertically
                          crossAxisAlignment: CrossAxisAlignment.center, // Centering horizontally
                          children: [
                            Text(
                              "📌",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TailwindColors.mossGreenDarker,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              promo['promo_title']!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TailwindColors.mossGreenDarker,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              promo['promo_description']!,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: TailwindColors.mossGreenDarker,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Berlaku hingga: ${promo['batas_penggunaan'] ?? '(Tidak ada batas)'}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: TailwindColors.sageDark,
                                  ),
                                  child: const Text('Update'),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: TailwindColors.sageDark,
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
                ),
              ),
            ),
    );
  }
}
