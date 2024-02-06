import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserOrderList extends StatefulWidget {
  const UserOrderList({Key? key}) : super(key: key);

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
        appBar: AppBar(title: const Text("Order list")),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('purchases')
                .where('userId', isEqualTo: userId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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

                  // Check if 'storeId' and 'totalAmount' exist in the order data
                  if (orderMap.containsKey('storeId') &&
                      orderMap.containsKey('totalAmount')) {
                    // Extract storeId and totalAmount from order data
                    dynamic storeIdDynamic = orderMap['storeId'];
                    String storeId =
                        storeIdDynamic is String ? storeIdDynamic : '';
                    double totalAmount =
                        double.tryParse(orderMap['totalAmount'].toString()) ??
                            0.0;

                    // Print the storeId and totalAmount to the console
                    print('StoreId for order ${orderData.id}: $storeId');
                    print(
                        'Total Amount for order ${orderData.id}: $totalAmount');

                    // Further processing or calling fetchStoreDetails method
                    return FutureBuilder(
                      future: fetchStoreDetails(storeId),
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>?>
                              storeDetailsSnapshot) {
                        if (storeDetailsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (storeDetailsSnapshot.hasError) {
                          return Text(
                              'Error fetching store details: ${storeDetailsSnapshot.error}');
                        }

                        Map<String, dynamic>? storeDetails =
                            storeDetailsSnapshot.data;
                        return FutureBuilder(
                          future: fetchUserRating(orderData.id),
                          builder: (context,
                              AsyncSnapshot<double?> userRatingSnapshot) {
                            if (userRatingSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (userRatingSnapshot.hasError) {
                              return Text(
                                  'Error fetching user rating: ${userRatingSnapshot.error}');
                            }

                            double? userRating = userRatingSnapshot.data;

                            String name =
                                storeDetails?['name'] ?? 'Unknown Store';

                            return Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 150.h,
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 100.w,
                                                      height: 110.h,
                                                      decoration:
                                                          const BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                        image: AssetImage(
                                                            "assets/store.jpeg"),
                                                      )),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        RatingBar.builder(
                                                          initialRating:
                                                              userRating ?? 0,
                                                          itemCount: 5,
                                                          itemSize: 15,
                                                          direction:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {
                                                            updateRating(
                                                                orderData.id,
                                                                rating);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Store Name: $name",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      "Date: ${_formatTimestamp(orderMap['timestamp'])}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      "Amount: Rs.${totalAmount.toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
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
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                        border: Border.all()),
                                                    child: Center(
                                                      child: Text(
                                                        orderMap['status'] ??
                                                            'Pending',
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
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
                                                    name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(), // If storeDetails is null, show an empty container
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  ;
                },
              );
            }));
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  Future<Map<String, dynamic>?> fetchStoreDetails(String storeId) async {
    try {
      // Check if storeId is empty or null
      if (storeId.isEmpty) {
        print('Error: Invalid storeId for fetchStoreDetails');
        return null;
      }

      print(
          'Checking if storeId exists: $storeId'); // Print storeId to the console

      final storeSnapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .where('storeId', isEqualTo: storeId)
          .get();

      // Check if any document exists with the given storeId
      if (storeSnapshot.docs.isNotEmpty) {
        final storeData =
            storeSnapshot.docs.first.data() as Map<String, dynamic>;

        print('Store found for storeId: $storeId');
        print('Store Name: ${storeData['name']}');

        return {
          'name': storeData['name'],
        };
      } else {
        print('Error: Store not found for storeId: $storeId');
        return null;
      }
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
          final ratingData = ratingSnapshot.docs.first.data();
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
        final name = user.displayName ?? 'Unknown User';

        await FirebaseFirestore.instance.collection('reviews').add({
          'userId': userId,
          'name': name,
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
