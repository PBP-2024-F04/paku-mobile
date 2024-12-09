import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:paku/colors.dart'; // Import colors.dart for styling
import 'package:paku/widgets/left_drawer.dart';

class Promos extends StatelessWidget {
  // Fetch promo data from Django backend
  Future<List<Map<String, dynamic>>> fetchPromos() async {
    final response = await http.get(Uri.parse('http://localhost:8000/promos/promo_list_json/'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load promos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PaKu")),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title text "Promos"
            Text(
              "Promos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.mossGreenDarker,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Jangan lewatkan promo-promo berikut! Waktu terbatas!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Container with padding and border
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0), // Padding around the container
                child: Container(
                  padding: const EdgeInsets.only(left: 48.0, right: 48.0, top: 0.0, bottom: 0.0),
                  decoration: BoxDecoration(
                    color: TailwindColors.peachDarker, // Background color of the container
                    borderRadius: BorderRadius.zero, // No rounded corners
                    border: Border.all(
                      color: TailwindColors.peachDarkActive, // Border color
                      width: 16, // Border width
                    ),
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchPromos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Belum ada promo yang kamu tambahkan!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(snapshot.data!.length, (index) {
                            var promo = snapshot.data![index];
                            return Container(
                              width: 350, // Fixed width for each card
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
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
