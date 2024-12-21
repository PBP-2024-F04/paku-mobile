import 'package:flutter/material.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:paku/screens/reviews/edit_review.dart';
import 'package:paku/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/reviews/models/review.dart';

class MyReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;

  const MyReviewCard({
    super.key,
    required this.review,
    required this.onTap,
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
        title: Text('Delete Review'),
        content: Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            child: const Text("Delete"),
            onPressed: () async {
              await request.postJson(
                "http://localhost:8000/reviews/json/reviews/me/${review.id}/delete/",
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
      color: TailwindColors.whiteDefault,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      review.product.fields.productName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: TailwindColors.mossGreenDefault,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.product.fields.restaurant,
                      style: TextStyle(
                        fontSize: 14,
                        color: TailwindColors.peachDefault,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp${review.product.fields.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: TailwindColors.peachDefault,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 24,
              thickness: 1,
              color: TailwindColors.sageLight,
            ),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: TailwindColors.sageDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: index < review.rating ? TailwindColors.yellowDefault : TailwindColors.whiteDark,
                );
              }),
            ),
            const SizedBox(height: 12),
  
            Text(
              '- ${review.user.username} | ${review.createdAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 12,
                color: TailwindColors.whiteDarkHover,
                fontStyle: FontStyle.italic,
              ),
            ),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  color: TailwindColors.mossGreenDefault,
                  onPressed: () => _editReview(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: TailwindColors.redDefault,
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
