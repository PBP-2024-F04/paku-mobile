import 'package:flutter/material.dart';

class CreateReviewPage extends StatefulWidget {
  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // FormKey ditambahkan di sini

  void _submitReview() {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      // Kirim review jika validasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );

      // Reset form
      _rating = 0;
      _commentController.clear();
    } else {
      // Jika tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a rating and comment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write a Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Membungkus widget dengan Form
          key: _formKey, // Menambahkan key form
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null; // Jika valid
                },
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
      ),
    );
  }
}
