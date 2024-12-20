import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/reviews/widgets/review_card.dart';
import 'package:paku/screens/reviews/widgets/my_review_card.dart';
import 'package:paku/screens/reviews/create_review.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedRating = 'all';

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

  Future<List<Review>> _fetchAllReviews(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/reviews/get-reviews-flutter/',
    );
    
    if (response is List<dynamic>) {
      return response.map((data) => Review.fromJson(data)).toList();
    }
    
    return [];
  }

  Future<List<Review>> _fetchMyReviews(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/reviews/get-my-reviews-flutter/',
    );
    
    if (response is List<dynamic>) {
      return response.map((data) => Review.fromJson(data)).toList();
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'All Reviews'),
              Tab(text: 'My Reviews'),
            ],
            indicatorColor: TailwindColors.whiteActive,
            labelColor: TailwindColors.whiteActive,
            unselectedLabelColor: TailwindColors.whiteDarker,
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Reviews Tab
                FutureBuilder(
                  future: _fetchAllReviews(request),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      final filteredReviews = snapshot.data.where((review) {
                        if (selectedRating == 'all') return true;
                        return review.rating.toString() == selectedRating;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredReviews.length,
                        itemBuilder: (context, index) {
                          final review = filteredReviews[index];
                          final reviewData = {
                            'id': review.id,
                            'role': review.user.role,
                            'product_name': review.product.productName,
                            'restaurant': review.product.restaurant,
                            'price': review.product.price,
                            'rating': review.rating,
                            'comment': review.comment,
                            'username': review.user.username,
                            'created_at': review.createdAt,
                          };

                          return ReviewCard(review: reviewData);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No reviews found'),
                      );
                    }
                  },
                ),
                // My Reviews Tab
                FutureBuilder(
                  future: _fetchMyReviews(request),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      final filteredReviews = snapshot.data.where((review) {
                        if (selectedRating == 'all') return true;
                        return review.rating.toString() == selectedRating;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredReviews.length,
                        itemBuilder: (context, index) {
                          final review = filteredReviews[index];
                          final reviewData = {
                            'id': review.id,
                            'role': review.user.role,
                            'product_name': review.product.productName,
                            'restaurant': review.product.restaurant,
                            'price': review.product.price,
                            'rating': review.rating,
                            'comment': review.comment,
                            'username': review.user.username,
                            'created_at': review.createdAt,
                          };

                          return MyReviewCard(review: reviewData);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No reviews found'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CreateReviewPage()),
      //     );
      //     if (result == true) {
      //       setState(() {}); // Refresh the page
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}