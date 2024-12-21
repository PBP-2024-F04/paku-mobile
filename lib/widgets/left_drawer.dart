import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/promos/promos.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  Future<String?> _fetchUserRole(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/profile/json/',
    );

    return response["role"];
  }

  void _logout(BuildContext context, CookieRequest request) async {
    final response =
        await request.logout("http://localhost:8000/accounts/auth/logout/");
    String message = response["message"];

    if (context.mounted) {
      if (response['success']) {
        String username = response["username"];
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("$message Sampai jumpa, $username.")),
          );

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    return Drawer(
      child: FutureBuilder(
        future: _fetchUserRole(request),
        builder: (context, AsyncSnapshot snapshot) => ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PaKu",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    "Jelajahi kuliner Palu!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            if (snapshot.hasData)
              if (snapshot.data == "Merchant")
                ..._merchantButtons(context)
              else
                ..._foodieButtons(context)
            else
              const Center(child: CircularProgressIndicator()),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context, request);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _merchantButtons(BuildContext context) => [
        ListTile(
          leading: const Icon(Icons.food_bank_outlined),
          title: const Text('My Products'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Products()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Timeline'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimelineMainPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.discount_outlined),
          title: const Text('My Promos'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPromos()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text('Reviews'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
        ),
      ];

  List<Widget> _foodieButtons(BuildContext context) => [
        ListTile(
          leading: const Icon(Icons.food_bank_outlined),
          title: const Text('Products'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Products()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Timeline'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimelineMainPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_border),
          title: const Text('Favorites'),
          onTap: () {
            // Navigasi ke halaman Favorites
          },
        ),
        ListTile(
          leading: const Icon(Icons.discount_outlined),
          title: const Text('Promos'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Promos()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text('Reviews'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
        ),
      ];
}
