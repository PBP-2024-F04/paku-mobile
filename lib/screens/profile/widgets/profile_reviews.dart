import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/screens/reviews/widgets/review_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/products/products.dart';

class ProfileReviewsPage extends StatefulWidget {
  final Profile profile;

  const ProfileReviewsPage(this.profile, {super.key});

  @override
  State<ProfileReviewsPage> createState() => _ProfileReviewsPageState();
}

class _ProfileReviewsPageState extends State<ProfileReviewsPage> {
  Future<List<Review>> _fetchReviews(BuildContext context, CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/profile/json/${widget.profile.username}/reviews',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Review.fromJson(data)).toList();
    }

    return [];
  }

  Widget _reviewsBuilder(
    BuildContext context,
    AsyncSnapshot<List<Review>> snapshot,
  ) {
    if (snapshot.hasData && snapshot.data is List) {
      if (snapshot.data!.isEmpty) {
        return const Center(child: Text("Belum ada review."));
      }

      return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final review = snapshot.data![index];
          return ReviewCard(
            review: review,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: review.product,
                  ),
                ),
              );
            }
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
        future: _fetchReviews(context, request),
        builder: _reviewsBuilder,
    );
  }
}
