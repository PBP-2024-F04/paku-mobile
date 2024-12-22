import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/reviews/create_review.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/screens/reviews/widgets/product_review_card.dart';

class ProductReviewPage extends StatefulWidget {
  final String productId;

  const ProductReviewPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  String? selectedRating = 'all';

  Future<List<Review>> _fetchReviews(BuildContext context, CookieRequest request) async {
    try {
      final response = await request.get(
        'http://localhost:8000/reviews/json/product/${widget.productId}/reviews/',
      );

      if (response is List) {
        return response.map((item) => Review.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching reviews: $e')),
        );
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TailwindColors.mossGreenActive,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Reviews',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Container(
        color: TailwindColors.yellowLight, 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Review Product",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TailwindColors.peachDarkActive,
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedRating,
              isExpanded: true,
              hint: const Text('Filter by rating'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRating = newValue;
                });
              },
              items: <String>['all', '5', '4', '3', '2', '1']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'all' ? 'All Ratings' : '$value Stars'),
                );
              }).toList(),
              style: const TextStyle(color: TailwindColors.mossGreenDarker),
              dropdownColor: Colors.white, 
            ),
            const SizedBox(height: 16),


            Expanded(
              child: FutureBuilder<List<Review>>(
                future: _fetchReviews(context, request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No reviews available'));
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateReviewPage(
                        productId: widget.productId,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {}); 
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TailwindColors.mossGreenActive,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Write a Review",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
