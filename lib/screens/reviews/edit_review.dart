import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditReviewPage extends StatefulWidget {
  final Map<String, dynamic> review; 
  
  const EditReviewPage({super.key, required this.review});

  @override
  _EditReviewPageState createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late int _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.review['rating'];
    _commentController = TextEditingController(text: widget.review['comment']);
  }

  void _editReview(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/reviews/json/reviews/me/${widget.review['id']}/edit/",
      jsonEncode({
        'rating': _rating,
        'comment': _commentController.text,
      }),
    );

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ReviewPage()),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Failed to update review!')),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Your Review')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
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
              const SizedBox(height: 20),

              const Text(
                'Your Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Update your thoughts...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Review cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _editReview(context, request);
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}