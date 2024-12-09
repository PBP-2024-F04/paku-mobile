import 'package:flutter/material.dart';

class DeleteReviewPage extends StatelessWidget {
  final int reviewId;

  DeleteReviewPage({required this.reviewId});

  void _deleteReview(BuildContext context) {
    // Simulasi menghapus review
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review deleted successfully!')),
    );
    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Are you sure you want to delete this review?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _deleteReview(context),
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Use backgroundColor instead of primary
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
