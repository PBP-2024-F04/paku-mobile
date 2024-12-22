import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';

class ProfileFavoritesPage extends StatelessWidget {
  final Profile profile;

  const ProfileFavoritesPage(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Favorites");
  }
}
