import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paku/colors.dart';
import 'package:paku/screens/promos/models/promo.dart';
import 'package:paku/settings.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class Promos extends StatefulWidget {
  const Promos({super.key});

  @override
  State<Promos> createState() => _PromosState();
}

class _PromosState extends State<Promos> {
  Future<List<Promo>>? _future;
  String _query = "";

  Future<List<Promo>> _fetchPromos(CookieRequest request, {String query = ""}) async {
    final response = await request.get(
      Uri.parse('$apiURL/promos/promo_list_json/')
          .replace(queryParameters: {"query": query})
          .toString(),
    );

    if (response is List<dynamic>) {
      return response.map<Promo>((json) => Promo.fromJson(json)).toList();
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _future = _fetchPromos(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
              "Promos",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.mossGreenDarker,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Jangan lewatkan promo-promo berikut! Waktu terbatas!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SearchBar(
              hintText: 'Cari Promos...',
              elevation: WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: const BorderSide(
                    color: TailwindColors.mossGreenDark,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _query = value;
                  _future = _fetchPromos(request, query: _query);
                });
              },
              trailing: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _future = _fetchPromos(request, query: _query);
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: TailwindColors.peachDarker,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: TailwindColors.peachDarkActive,
                      width: 16,
                    ),
                  ),
                  child: FutureBuilder(
                    future: _future,
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
                            'Belum ada promo yang tersedia!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var promo = snapshot.data![index];
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "📌",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: TailwindColors.redHover,
                                          ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      promo.promoTitle,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: TailwindColors.mossGreenDarker,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'di ${promo.restaurantName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: TailwindColors.mossGreenDarker,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      promo.promoDescription,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: TailwindColors.mossGreenDarker,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Berlaku hingga: ${promo.batasPenggunaan != null ? DateFormat('dd-MM-yyyy').format(promo.batasPenggunaan!) : "Tidak ada batas"}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
