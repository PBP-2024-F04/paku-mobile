import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/home.dart';
<<<<<<< HEAD
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/promos/promos.dart';
=======
import 'package:paku/screens/timeline/timeline_main.dart';
>>>>>>> 4649e75baa2718ccf691b0d5aed3fafd31b9aa6e

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                ),
                Text(
                  "Jelajahi kuliner Palu!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
<<<<<<< HEAD
            leading: const Icon(Icons.discount_outlined),
            title: const Text('Promos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyPromos()),
=======
            leading: const Icon(Icons.home_outlined),
            title: const Text('Timeline'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TimelineMainPage()),
>>>>>>> 4649e75baa2718ccf691b0d5aed3fafd31b9aa6e
              );
            },
          ),
        ],
      ),
    );
  }
}
