import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:near_by_store/store%20keeper/StoreKeeperOrder.dart';

class StorekeepOrderList extends StatefulWidget {
  const StorekeepOrderList({Key? key}) : super(key: key);

  @override
  State<StorekeepOrderList> createState() => _StorekeepOrderListState();
}

class _StorekeepOrderListState extends State<StorekeepOrderList> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists && userData.data() != null) {
          setState(() {
            userId = userData['userId'];
          });
        } else {
          print('User document does not exist or does not contain "userId".');
        }
      } catch (e) {
        print('Error getting user data: $e');
      }
    }
  }

  Future<String?> getUserName(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userData = userDoc.data();

        if (userData != null && userData.containsKey('name')) {
          return userData['name'];
        } else {
          print(
              'User document does not contain "name" field. User data: $userData');
        }
      } else {
        print('User document not found for userId: $userId');
      }
    } catch (e) {
      print('Error getting user name: $e');
    }

    return null;
  }

  Future<String?> getStoreName(List<dynamic> storeIdList) async {
    try {
      // Assuming that you want to get the name for the first store in the list
      final storeId = storeIdList.first;

      final storeSnapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .where('storeId', isEqualTo: storeId)
          .where('storeId', whereIn: [storeId])
          .limit(1)
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        final storeDoc = storeSnapshot.docs.first;
        final storeData = storeDoc.data();

        if (storeData != null && storeData.containsKey('name')) {
          return storeData['name'].toString();
        } else {
          print(
              'Store document does not contain "name" field. Store data: $storeData');
        }
      } else {
        print('Store document not found for storeId: $storeId');
      }
    } catch (e) {
      print('Error getting store name: $e');
    }

    return null;
  }

  Future<void> printStoreIds() async {
    try {
      final purchasesSnapshot =
          await FirebaseFirestore.instance.collection('purchases').get();

      for (final purchaseDoc in purchasesSnapshot.docs) {
        final storeId = purchaseDoc['storeId'];
        print(' the StoreId: $storeId');
      }
    } catch (e) {
      print('Error fetching storeIds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Order view"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('purchases').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<QueryDocumentSnapshot> purchases = snapshot.data!.docs;

          // Sort purchases based on timestamp in descending order
          purchases.sort((a, b) {
            Timestamp timestampA = a['timestamp'] ?? Timestamp(0, 0);
            Timestamp timestampB = b['timestamp'] ?? Timestamp(0, 0);
            return timestampB.compareTo(timestampA);
          });

          // Print storeIds to console
          printStoreIds();

          return ListView.builder(
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreKeeperOrder(
                        totalAmount: purchases[index]['totalAmount'],
                        userId: userId,
                        purchaseId: purchases[index].id,
                      ),
                    ),
                  );
                },
                child: FutureBuilder(
                  future: getUserName(purchases[index]['userId']),
                  builder: (context, AsyncSnapshot<String?> userNameSnapshot) {
                    if (userNameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    String name = userNameSnapshot.data ?? 'Unknown';
                    Timestamp timestamp =
                        purchases[index]['timestamp'] ?? Timestamp(0, 0);
                    DateTime dateTime = timestamp.toDate();
                    String status = purchases[index]['status'] ?? 'Pending';

                    return FutureBuilder(
                      future: getStoreName(purchases[index]['storeId']),
                      builder:
                          (context, AsyncSnapshot<String?> storeNameSnapshot) {
                        if (storeNameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        String shopName = storeNameSnapshot.data ?? 'Unknown';
                        String formattedDate =
                            intl.DateFormat('dd MMM yyyy').format(dateTime);

                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xffD5F1E9),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage("assets/Ellipse 4.jpg"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name),
                                          Text(formattedDate),
                                          Text('Status: $status'),
                                          Text('Shop Name: $shopName'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.currency_rupee),
                                    ),
                                    Text(" ${purchases[index]['totalAmount']}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
