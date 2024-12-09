import 'package:flutter/material.dart';

class CreateReviewPage extends StatefulWidget {
  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();

  void _submitReview() {
    // Validasi dan kirim review
    if (_rating == 0 || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a rating and comment.')),
      );
      return;
    }

    // Simulasi mengirim review
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted successfully!')),
    );

    // Reset form
    _rating = 0;
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write a Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Field (Stars)
            Text('Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),

            // Comment Field
            Text('Your Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),

            // Submit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text('Submit Review'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context), // Cancel button
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
