import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/reviews/widgets/review_card.dart';
import 'package:paku/screens/reviews/widgets/my_review_card.dart';
import 'package:paku/screens/reviews/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:paku/screens/products/products.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
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
    try {
      final response = await request.get(
        'http://localhost:8000/reviews/json-reviews',
      );

      if (response is List<dynamic>) {
        final reviews = response.map((data) => Review.fromJson(data)).toList();

        if (selectedRating != 'all') {
          return reviews
              .where((review) => review.rating == int.parse(selectedRating!))
              .toList();
        }

        return reviews;
      }
      return [];
    } catch (e) {
      print('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<List<Review>> _fetchMyReviews(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://localhost:8000/reviews/json-reviews-me/',
      );

      if (response is List<dynamic>) {
        final reviews = response.map((data) => Review.fromJson(data)).toList();

        if (selectedRating != 'all') {
          return reviews
              .where((review) => review.rating == int.parse(selectedRating!))
              .toList();
        }

        return reviews;
      }
      return [];
    } catch (e) {
      print('Error fetching my reviews: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PaKu"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.rate_review),
                text: 'All Reviews',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'My Reviews',
              ),
            ],
            indicatorColor: TailwindColors.whiteActive,
            indicatorWeight: 3.0,
            labelColor: TailwindColors.whiteActive,
            unselectedLabelColor: TailwindColors.whiteDarker,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
            ),
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
                FutureBuilder(
                  future: _fetchAllReviews(request),
                  builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No reviews found.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final review = snapshot.data![index];
                        return ReviewCard(
                          review: review,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: review.product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                FutureBuilder(
                  future: _fetchMyReviews(request),
                  builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No reviews found.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final review = snapshot.data![index];
                        return MyReviewCard(
                          review: review,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: review.product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
