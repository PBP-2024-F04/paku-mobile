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
          "PaKu",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: TailwindColors.mossGreenDarker,
              ),
        ),
        backgroundColor: TailwindColors.sageDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centering vertically
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
              const SizedBox(height: 8),  // Memberikan jarak di bawah judul

              Text(
                "Jangan lewatkan promo-promo berikut! Waktu terbatas!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 64), 

              // Container dengan padding dan border
              Container(
                padding: const EdgeInsets.only(left: 64.0, right: 64.0, top: 16.0, bottom: 16.0),
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
                    : ListView.builder(
                        shrinkWrap: true,  // Agar ListView tidak mengisi seluruh ruang, hanya sebanyak item
                        physics: NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                        itemCount: promos.length,
                        itemBuilder: (context, index) {
                          var promo = promos[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: TailwindColors.whiteLight, // Set card color to white
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Set border radius to zero for sharp edges
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // Centering vertically
                                crossAxisAlignment: CrossAxisAlignment.center, // Centering horizontally
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
                                  const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
