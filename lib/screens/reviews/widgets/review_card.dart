import 'package:flutter/material.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/colors.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

