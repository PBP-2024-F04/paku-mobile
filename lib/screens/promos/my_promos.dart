import 'package:flutter/material.dart';
import 'package:paku/colors.dart'; // Import colors.dart untuk menggunakan TailwindColors
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MyPromos extends StatelessWidget {
  // Placeholder data untuk promo
  final List<Map<String, dynamic>> promos = [
    {
      'promo_title': 'Diskon 50% untuk Pembelian Pertama',
      'promo_description': 'Dapatkan diskon hingga 50% pada pembelian pertama.',
      'batas_penggunaan': '31 Desember 2024',
      'restaurant_name': 'Restoran A',
      'id': 1
    },
    {
      'promo_title': 'Gratis Ongkir!',
      'promo_description': 'Nikmati gratis ongkir untuk semua produk!',
      'batas_penggunaan': null,
      'restaurant_name': 'Restoran B',
      'id': 2
    },
    {
      'promo_title': 'Potongan 20% untuk Pembelian Kedua',
      'promo_description': 'Dapatkan potongan 20% pada pembelian kedua produk.',
      'batas_penggunaan': '15 Januari 2025',
      'restaurant_name': 'Restoran C',
      'id': 3
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PaKu",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: TailwindColors.mossGreenDarker,
              ),
        ),
        backgroundColor: TailwindColors.sageDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teks judul "Promos" yang selalu muncul
            Text(
              "Promos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.mossGreenDarker,
                  ),
            ),
            const SizedBox(height: 8), // Memberikan jarak di bawah judul

            Text(
              "Jangan lewatkan promo-promo berikut! Waktu terbatas!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16), // Memberikan jarak sebelum container scrollable

            // Container dengan padding dan border
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0), // Padding around the container
                child: Container(
                  padding: const EdgeInsets.only(left: 48.0, right: 48.0, top: 0.0, bottom: 0.0),
                  decoration: BoxDecoration(
                    color: TailwindColors.peachDarker, // Warna latar belakang container
                    borderRadius: BorderRadius.zero, // Tidak ada rounded corners
                    border: Border.all(
                      color: TailwindColors.peachDarkActive, // Warna border
                      width: 16, // Lebar border
                    ),
                  ),
                  child: promos.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada promo yang kamu tambahkan!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : SingleChildScrollView( // Make only the content inside the container scrollable
                          child: Column(
                            children: List.generate(promos.length, (index) {
                              var promo = promos[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 16),
                                color: TailwindColors.whiteDefault, // Set card color to white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Set border radius to zero for sharp edges
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                        promo['promo_title']!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: TailwindColors.mossGreenDarker,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        promo['promo_description']!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                      const SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/update_promos', // Go to the update page
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
                                            onPressed: () {},
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
                            }),
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
