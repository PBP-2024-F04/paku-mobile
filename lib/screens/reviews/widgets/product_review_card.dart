import 'package:flutter/material.dart';

class ProductReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ProductReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0, 
        horizontal: 4.0
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Stars
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < review['rating'] ? Icons.star : Icons.star_border,
                  color: index < review['rating'] ? Colors.amber : Colors.grey,
                  size: 20,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Review Comment
            Text(
              '${review['comment']}',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // User Info and Date
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${review['username']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  review['created_at'].toLocal().toString().split(' ')[0],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
