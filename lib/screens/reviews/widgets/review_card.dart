import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              review['restaurant'],
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'Price: Rp${review['price'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 10),
            // Review Comment
            Text(review['comment']),
            SizedBox(height: 10),
            // Rating
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review['rating'] ? Icons.star : Icons.star_border,
                  color: index < review['rating'] ? Colors.amber : Colors.grey,
                );
              }),
            ),
            SizedBox(height: 10),
            // User Info
            Text(
              '- by ${review['username']} | ${review['created_at'].toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}