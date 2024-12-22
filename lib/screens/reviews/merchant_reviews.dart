import 'package:flutter/material.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/reviews/widgets/product_review_card.dart';

class MerchantReviewPage extends StatefulWidget {
  const MerchantReviewPage({super.key});

  @override
  State<MerchantReviewPage> createState() => _MerchantReviewPageState();
}

class _MerchantReviewPageState extends State<MerchantReviewPage> {
  String? selectedRating = 'all';

  Future<List<Review>> _fetchMerchantReviews(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://localhost:8000/reviews/json-merchant-reviews/',
      );

      if (response is List<dynamic>) {
        final reviews = response.map((data) => Review.fromJson(data)).toList();

        if (selectedRating != 'all') {
          return reviews
              .where((review) => review.rating == int.parse(selectedRating!))
              .toList();
        }

        return reviews;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product Reviews"),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  "Filter by rating: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedRating,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRating = newValue;
                      });
                    },
                    items: <String>['all', '5', '4', '3', '2', '1']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'all' ? 'All Ratings' : '$value Stars',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchMerchantReviews(request),
              builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No reviews found for your products.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var reviews = snapshot.data!;

                if (selectedRating != 'all') {
                  reviews = reviews
                      .where((review) =>
                          review.rating.toString() == selectedRating)
                      .toList();
                }

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ProductReviewCard(
                      review: {
                        'username': review.user.username,
                        'comment': review.comment,
                        'rating': review.rating,
                        'created_at': review.createdAt,
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
