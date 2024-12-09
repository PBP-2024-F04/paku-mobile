import 'package:flutter/material.dart';
import 'package:paku/screens/accounts/home.dart';
import 'package:paku/screens/promos/my_promos.dart';
import 'package:paku/screens/promos/promos.dart';
import 'package:paku/screens/timeline/timeline_main.dart';

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
            leading: const Icon(Icons.discount_outlined),
            title: const Text('Promos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Promos()),
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
        ],
      ),
    );
  }
}
