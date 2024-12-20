import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/reviews/review_card.dart';
import 'package:paku/screens/reviews/create_review.dart';

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
        title: const Text("PaKu"),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Ukuran toolbar default
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'All Reviews'),
              Tab(text: 'My Reviews'),
            ],
            indicatorColor: TailwindColors.whiteActive, // Warna garis bawah tab yang aktif
            labelColor: TailwindColors.whiteActive, // Warna teks tab yang aktif
            unselectedLabelColor: TailwindColors.whiteDarker, // Warna teks tab yang tidak aktif
          ),
        ),
      ),
      drawer: const LeftDrawer(),
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
          // Add Review Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to CreateReviewPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateReviewPage()),
                );
              },
              child: Text('Create Review'),
            ),
          ),
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
