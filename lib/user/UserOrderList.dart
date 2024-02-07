import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrderList extends StatefulWidget {
  const UserOrderList({Key? key}) : super(key: key);

  @override
  State<UserOrderList> createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  late String? currentUserId;
  late FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null || currentUserId!.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Order list")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchases')
            .where('userId', isEqualTo: currentUserId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final purchases = snapshot.data?.docs ?? [];

          if (purchases.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          return ListView.builder(
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final purchase = purchases[index];
              final data = purchase.data() as Map<String, dynamic>;

              final List<dynamic> storeIdList = data['storeId'];
              final String storeId =
                  storeIdList.isNotEmpty ? storeIdList.first.toString() : '';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('add_store')
                    .doc(storeId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Container();
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Container();
                  }

                  final storeData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final String name = storeData['name'] ?? '';
                  final totalAmount = data['totalAmount'];
                  final double? totalAmountDouble =
                      parseTotalAmount(totalAmount);

                  final date = data['timestamp'] as Timestamp?;
                  final status = data['status'] as String?;

                  if (totalAmountDouble == null ||
                      date == null ||
                      status == null) {
                    return Container();
                  }

                  return Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 150.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffD5F1E9),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          FutureBuilder<String>(
                                            future: getStoreImageUrl(storeId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }

                                              if (snapshot.hasError) {
                                                return Container();
                                              }

                                              final storeImageUrl =
                                                snapshot.data ?? '';

                                              return Container(
                                                width: 100.w,
                                                height: 110.h,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        'storeImageURL'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RatingBar.builder(
                                                initialRating:
                                                    data['userRating']
                                                            as double? ??
                                                        0,
                                                itemCount: 5,
                                                itemSize: 15,
                                                direction: Axis.horizontal,
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  updateRating(
                                                      purchase.id, rating);
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Store Name: $name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Date: ${_formatTimestamp(date)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                              "Total Amount: $totalAmountDouble"),
                                          Text(
                                            "Status: $status",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Future<String> getStoreImageUrl(String storeId) async {
    try {
      final storeDoc = await FirebaseFirestore.instance
          .collection('add_store')
          .doc(storeId)
          .get();

      if (storeDoc.exists) {
        final storeData = storeDoc.data() as Map<String, dynamic>;
        final storeImage = storeData['store_images'] as String?;
        return storeImage ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching store image URL: $e');
      return '';
    }
  }

  double? parseTotalAmount(String? totalAmount) {
    if (totalAmount == null) return null;
    try {
      return double.parse(totalAmount.replaceAll('Rs.', '').trim());
    } catch (e) {
      print('Error parsing totalAmount: $e');
      return null;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    return timestamp.toDate().toString();
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
