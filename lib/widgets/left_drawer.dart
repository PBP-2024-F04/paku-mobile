import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/accounts/login.dart';
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/promos/promos.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:paku/screens/products/products.dart';
import 'package:paku/screens/timeline/timeline_main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

Future<String> fetchUserRole(CookieRequest request) async {
  try {
    final response = await request.get('http://localhost:8000/accounts/json/get_user_role/');

    if (response != null && response['role'] != null) {
      return response['role'];
    } else {
      throw Exception('Role not found in response');
    }
  } catch (e) {
    print('Error fetching user role: $e');
    return 'Error fetching role';
  }
}

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserRole();
    });
  }

  Future<void> loadUserRole() async {
    final request = context.read<CookieRequest>(); 
    final role = await fetchUserRole(request);
    setState(() {
      userRole = role;
    });
  }

  void _logout(BuildContext context, CookieRequest request) async {
    final response = await request.logout("http://localhost:8000/accounts/auth/logout/");
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
      child: userRole == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                if (userRole == 'Foodie') ...[
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
                ] else if (userRole == 'Merchant') ...[
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
                ],
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
    );
  }
}