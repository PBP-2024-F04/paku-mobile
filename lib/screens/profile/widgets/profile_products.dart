import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';

class ProfileProductsPage extends StatelessWidget {
  final Profile profile;

  const ProfileProductsPage(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Products");
  }
}
