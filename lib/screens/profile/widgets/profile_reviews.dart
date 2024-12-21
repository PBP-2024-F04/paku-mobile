import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';

class ProfileReviewsPage extends StatelessWidget {
  final Profile profile;

  const ProfileReviewsPage(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Reviews");
  }
}
