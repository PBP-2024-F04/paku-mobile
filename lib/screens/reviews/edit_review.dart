import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:paku/screens/reviews/reviews.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:paku/colors.dart'; 

class EditReviewPage extends StatefulWidget {
  final Review review;

  const EditReviewPage({super.key, required this.review});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late int _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.review.rating;
    _commentController = TextEditingController(text: widget.review.comment);
  }

  void _editReview(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/reviews/json/reviews/me/${widget.review.id}/edit/",
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
      appBar: AppBar(
        title: const Text('Edit Your Review'),
        backgroundColor: TailwindColors.mossGreenDefault,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: TailwindColors.whiteDefault,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      _rating > index ? Icons.star : Icons.star_border,
                      color: TailwindColors.yellowDefault,
                      size: 32,
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Update your thoughts...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: TailwindColors.sageLight,
                  filled: true,
                ),
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Review cannot be empty!";
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 16),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: TailwindColors.mossGreenDefault,
                      foregroundColor: TailwindColors.whiteDefault,
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: TailwindColors.peachDefault,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
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
