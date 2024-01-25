import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserOrderList extends StatefulWidget {
  const UserOrderList({Key? key});

  @override
  State<UserOrderList> createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final userId = user?.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Order list")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchases')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final orders = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index];
              final orderMap = orderData.data() as Map<String, dynamic>;
              final totalAmount =
                  double.tryParse(orderMap['totalAmount'].toString()) ?? 0.0;

              // Extract storeId from order data
              String storeId = orderMap['storeId'] ?? '';

              return FutureBuilder(
                future: fetchStoreDetails(storeId),
                builder: (context,
                    AsyncSnapshot<Map<String, dynamic>?> storeDetailsSnapshot) {
                  if (storeDetailsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (storeDetailsSnapshot.hasError) {
                    return Text('Error: ${storeDetailsSnapshot.error}');
                  }

                  Map<String, dynamic>? storeDetails =
                      storeDetailsSnapshot.data;

                  // Display order details with store information and user rating
                  return FutureBuilder(
                    future: fetchUserRating(orderData.id),
                    builder:
                        (context, AsyncSnapshot<double?> userRatingSnapshot) {
                      if (userRatingSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (userRatingSnapshot.hasError) {
                        return Text('Error: ${userRatingSnapshot.error}');
                      }

                      double? userRating = userRatingSnapshot.data;

                      return Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: InkWell(
                          onTap: () {
                            // TODO: Implement navigation to order details page
                          },
                          child: Container(
                            height: 200.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffD5F1E9)),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 110.w,
                                                height: 130.h,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/store.jpeg"),
                                                )),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating:
                                                        userRating ?? 0,
                                                    itemCount: 5,
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      updateRating(
                                                          orderData.id, rating);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  "Date: ${_formatTimestamp(orderMap['timestamp'])}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  "Amount: Rs.${totalAmount.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              height: 25.h,
                                              width: 70.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  border: Border.all()),
                                              child: Center(
                                                child: Text(
                                                  orderMap['status'] ??
                                                      'Pending',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                // Display store information here
                                storeDetails != null
                                    ? Column(
                                        children: [
                                          Image.network(
                                            storeDetails['image']!,
                                            width: 50.w,
                                            height: 50.h,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 200.w,
                                            child: Text(
                                              storeDetails['name'] ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(), // If storeDetails is null, show an empty container
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  Future<Map<String, dynamic>?> fetchStoreDetails(String storeId) async {
    try {
      // Check if storeId is empty or null
      if (storeId == null || storeId.isEmpty) {
        print('Error: Invalid storeId');
        return null;
      }

      final storeSnapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .doc(storeId)
          .get();

      // Check if the store exists
      if (!storeSnapshot.exists) {
        print('Error: Store not found for storeId: $storeId');
        return null;
      }

      final storeData = storeSnapshot.data() as Map<String, dynamic>;

      return {
        'name': storeData['name'],
        'image': storeData['image'],
      };
    } catch (e) {
      print('Error fetching store details: $e');
      return null;
    }
  }

  Future<double?> fetchUserRating(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;

        final ratingSnapshot = await FirebaseFirestore.instance
            .collection('reviews')
            .where('userId', isEqualTo: userId)
            .where('orderId', isEqualTo: orderId)
            .get();

        if (ratingSnapshot.docs.isNotEmpty) {
          // If a rating exists, return the first one
          final ratingData =
              ratingSnapshot.docs.first.data() as Map<String, dynamic>;
          return ratingData['rating']?.toDouble();
        }
      }

      return null; // Return null if no rating is found
    } catch (e) {
      print('Error fetching user rating: $e');
      return null;
    }
  }

  Future<void> updateRating(String orderId, double rating) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userName = user.displayName ?? 'Unknown User';

        await FirebaseFirestore.instance.collection('reviews').add({
          'userId': userId,
          'userName': userName,
          'orderId': orderId,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating rating: $e');
    }
  }
}
