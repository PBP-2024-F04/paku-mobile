import 'package:flutter/material.dart';
import 'package:paku/colors.dart'; // Import colors.dart untuk menggunakan TailwindColors

class MyPromo extends StatelessWidget {
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
                color: TailwindColors.mossGreenDarker, // Gunakan warna dari TailwindColors
              ),
        ),
        backgroundColor: TailwindColors.yellowDefault, // Gunakan warna dari TailwindColors
      ),
      body: promos.isEmpty
          ? const Center(
              child: Text(
                'Belum ada promo yang kamu tambahkan!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: promos.length,
                itemBuilder: (context, index) {
                  var promo = promos[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promo['promo_title']!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TailwindColors.mossGreenDarker, // Gunakan warna dari TailwindColors
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            promo['promo_description']!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: TailwindColors.mossGreenDarker, // Warna teks yang konsisten
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Berlaku hingga: ${promo['batas_penggunaan'] ?? '(Tidak ada batas)'}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey, // Gunakan warna abu-abu untuk teks kecil
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Belum ada aksi untuk update
                                },
                                child: const Text('Update'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Belum ada aksi untuk delete
                                },
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
    );
  }
}
