import 'package:flutter/material.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:paku/screens/reviews/edit_review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const MyReviewCard({
    super.key,
    required this.review,
  });

  void _editReview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReviewPage(review: review),
      ),
    );
  }

  void _deleteReview(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            child: const Text("Delete"),
            onPressed: () async {
              await request.postJson(
                "http://localhost:8000/reviews/json/reviews/me/${review['id']}/delete/",
                "",
              );

              if (context.mounted) {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ReviewPage(),
                    ),
                  );
              }
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info
            Text(
              review['product_name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              review['restaurant'],
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Price: Rp${review['price'].toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 10),
            // Review Comment
            Text(review['comment']),
            const SizedBox(height: 10),
            // Rating
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review['rating'] ? Icons.star : Icons.star_border,
                  color: index < review['rating'] ? Colors.amber : Colors.grey,
                );
              }),
            ),
            const SizedBox(height: 10),
            // User Info
            Text(
              '- by ${review['username']} | ${review['created_at'].toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // Edit and Delete Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editReview(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteReview(context, request),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
