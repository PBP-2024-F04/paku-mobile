import 'package:flutter/material.dart';
import 'package:';
import 'package:paku/screens/reviews/edit_review.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    home: ReviewPage(),
  ));
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedRating = 'all';

  // Dummy data for reviews
  List<Map<String, dynamic>> allReviews = [
    {
      'id': 1,
      'product_name': 'Burger',
      'restaurant': 'Restoran A',
      'price': 9.99,
      'rating': 5,
      'comment': 'Burgernya sangat enak dan juicy!',
      'username': 'KulinerManiak1',
      'created_at': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': 2,
      'product_name': 'Nasi Goreng',
      'restaurant': 'Restoran B',
      'price': 7.50,
      'rating': 4,
      'comment': 'Nasi gorengnya enak, tapi sedikit kurang pedas.',
      'username': 'FoodHunter88',
      'created_at': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'id': 3,
      'product_name': 'Mie Ayam',
      'restaurant': 'Restoran C',
      'price': 5.00,
      'rating': 3,
      'comment': 'Mie ayam biasa saja, topping ayamnya terlalu sedikit.',
      'username': 'MieLovers',
      'created_at': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 4,
      'product_name': 'Sate Ayam',
      'restaurant': 'Restoran D',
      'price': 8.00,
      'rating': 5,
      'comment': 'Sate ayamnya empuk dan bumbunya sangat gurih!',
      'username': 'SateEnakBanget',
      'created_at': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 5,
      'product_name': 'Bakso',
      'restaurant': 'Restoran E',
      'price': 6.00,
      'rating': 4,
      'comment': 'Baksonya enak dan kuahnya gurih, tapi porsinya kecil.',
      'username': 'BaksoLover',
      'created_at': DateTime.now().subtract(Duration(hours: 20)),
    },
    {
      'id': 6,
      'product_name': 'Ayam Geprek',
      'restaurant': 'Restoran F',
      'price': 6.50,
      'rating': 5,
      'comment': 'Ayam geprek sangat pedas, sesuai selera saya!',
      'username': 'PedasEnak',
      'created_at': DateTime.now().subtract(Duration(days: 7)),
    },
    {
      'id': 7,
      'product_name': 'Rendang',
      'restaurant': 'Restoran G',
      'price': 10.00,
      'rating': 4,
      'comment': 'Rendangnya enak, tapi terlalu banyak lemak.',
      'username': 'RendangLover',
      'created_at': DateTime.now().subtract(Duration(days: 10)),
    },
    {
      'id': 8,
      'product_name': 'Es Cendol',
      'restaurant': 'Restoran H',
      'price': 3.50,
      'rating': 5,
      'comment': 'Es cendol segar dan manis, cocok untuk cuaca panas.',
      'username': 'SegarManis',
      'created_at': DateTime.now().subtract(Duration(days: 15)),
    },
    {
      'id': 9,
      'product_name': 'Pempek',
      'restaurant': 'Restoran I',
      'price': 4.50,
      'rating': 3,
      'comment': 'Pempeknya kurang kenyal dan kuah cuko kurang mantap.',
      'username': 'PempekMania',
      'created_at': DateTime.now().subtract(Duration(days: 12)),
    },
    {
      'id': 10,
      'product_name': 'Martabak Manis',
      'restaurant': 'Restoran J',
      'price': 8.50,
      'rating': 5,
      'comment': 'Martabaknya lembut, isian cokelat kejunya melimpah!',
      'username': 'MartabakLover',
      'created_at': DateTime.now().subtract(Duration(days: 8)),
    },
  ];

  List<Map<String, dynamic>> myReviews = [
    {
      'id': 3,
      'product_name': 'Mie Ayam',
      'restaurant': 'Restoran C',
      'price': 5.00,
      'rating': 3,
      'comment': 'Mie ayam biasa saja, topping ayamnya terlalu sedikit.',
      'username': 'MieLovers',
      'created_at': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 5,
      'product_name': 'Bakso',
      'restaurant': 'Restoran E',
      'price': 6.00,
      'rating': 4,
      'comment': 'Baksonya enak dan kuahnya gurih, tapi porsinya kecil.',
      'username': 'BaksoLover',
      'created_at': DateTime.now().subtract(Duration(hours: 20)),
    },
    {
      'id': 9,
      'product_name': 'Pempek',
      'restaurant': 'Restoran I',
      'price': 4.50,
      'rating': 3,
      'comment': 'Pempeknya kurang kenyal dan kuah cuko kurang mantap.',
      'username': 'PempekMania',
      'created_at': DateTime.now().subtract(Duration(days: 12)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateReview(int id, int newRating, String newComment) {
    setState(() {
      final reviewIndex = allReviews.indexWhere((review) => review['id'] == id);
      if (reviewIndex != -1) {
        allReviews[reviewIndex]['rating'] = newRating;
        allReviews[reviewIndex]['comment'] = newComment;
      }
    });
  }

  void deleteReview(int id) {
    setState(() {
      allReviews.removeWhere((review) => review['id'] == id);
      myReviews.removeWhere((review) => review['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Reviews'),
            Tab(text: 'My Reviews'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedRating,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRating = newValue;
                });
              },
              items: <String>['all', '5', '4', '3', '2', '1']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'all' ? 'All Ratings' : '$value Stars'),
                );
              }).toList(),
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Reviews Tab
                ListView(
                  children: allReviews
                      .where((review) {
                        if (selectedRating == 'all') return true;
                        return review['rating'].toString() == selectedRating;
                      })
                      .map((review) => ReviewCard(
                            review: review,
                            onDelete: deleteReview,
                            onEdit: (newRating, newComment) => updateReview(
                                review['id'], newRating, newComment),
                          ))
                      .toList(),
                ),
                // My Reviews Tab
                ListView(
                  children: myReviews
                      .where((review) {
                        if (selectedRating == 'all') return true;
                        return review['rating'].toString() == selectedRating;
                      })
                      .map((review) => ReviewCard(
                            review: review,
                            onDelete: deleteReview,
                            onEdit: (newRating, newComment) => updateReview(
                                review['id'], newRating, newComment),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final Function(int) onDelete;
  final Function(int, String) onEdit;

  const ReviewCard(
      {required this.review, required this.onDelete, required this.onEdit});

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
              'Price: \$${review['price'].toStringAsFixed(2)}',
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
            // Edit and Delete Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReviewPage(
                          initialRating: review['rating'],
                          initialComment: review['comment'],
                        ),
                      ),
                    );
                    if (result != null) {
                      onEdit(result['rating'], result['comment']);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDelete(review['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
