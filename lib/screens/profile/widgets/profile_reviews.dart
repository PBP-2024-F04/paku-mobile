import 'package:flutter/material.dart';
import 'package:paku/screens/profile/models/profile.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/screens/reviews/widgets/my_review_card.dart';
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
  Future<List<Review>> _fetchMyReviews(
      BuildContext context, CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/reviews/json-reviews-me/',
    );

    if (response is List<dynamic>) {
      return response.map((data) => Review.fromJson(data)).toList();
    }

    return [];
  }

  Widget _myReviewsBuilder(
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
          return MyReviewCard(
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: FutureBuilder(
        future: _fetchMyReviews(context, request),
        builder: _myReviewsBuilder,
      ),
    );
  }
}
