import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:near_by_store/store%20keeper/StoreKeeperOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorekeepOrderList extends StatefulWidget {
  const StorekeepOrderList({
    Key? key,
  }) : super(key: key);

  @override
  State<StorekeepOrderList> createState() => _StorekeepOrderListState();
}

class _StorekeepOrderListState extends State<StorekeepOrderList> {
  late String userId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('store_keeper_id') ?? '';
    });
    print('store_keeper_id: $userId');
  }

  Future<String?> getUserName(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['name'];
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
      final storeId = storeIdList.first;
      final storeSnapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .doc(storeId)
          .get();

      if (storeSnapshot.exists) {
        return storeSnapshot['name'].toString();
      } else {
        print('Store document not found for storeId: $storeId');
      }
    } catch (e) {
      print('Error getting store name: $e');
    }

    return null;
  }

  Future<bool> isUserAllowed(String storeId) async {
    try {
      final storeSnapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .doc(storeId)
          .get();

      if (storeSnapshot.exists) {
        final storeUserId = storeSnapshot['userId'];
        return storeUserId == userId;
      } else {
        print('Store document not found for storeId: $storeId');
      }
    } catch (e) {
      print('Error checking user permission: $e');
    }

    return false;
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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> purchases = snapshot.data!.docs;
          purchases.sort((a, b) {
            Timestamp timestampA = a['timestamp'] ?? Timestamp(0, 0);
            Timestamp timestampB = b['timestamp'] ?? Timestamp(0, 0);
            return timestampB.compareTo(timestampA);
          });

          if (purchases.isEmpty) {
            return Center(child: Text('No orders available'));
          }

          return ListView.builder(
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              List<dynamic> storeIds = purchases[index]['storeId'];
              return FutureBuilder(
                future: Future.wait([
                  getUserName(purchases[index]['userId']),
                  getStoreName(storeIds),
                  isUserAllowed(storeIds.first),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final userName = snapshot.data![0] as String?;
                  final storeName = snapshot.data![1] as String?;
                  final isAllowed = snapshot.data![2] as bool;

                  if (isAllowed) {
                    Timestamp timestamp =
                        purchases[index]['timestamp'] ?? Timestamp(0, 0);
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        intl.DateFormat('dd MMM yyyy').format(dateTime);
                    String status = purchases[index]['status'] ?? 'Pending';

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the StoreKeeperOrder screen
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
                      child: Padding(
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
                                        Text(
                                          userName ?? 'Unknown',
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontSize: 20),
                                        ),
                                        Text(formattedDate),
                                        Text('Status: $status',
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                        Text(
                                          'Shop Name: $storeName',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.currency_rupee),
                                  ),
                                  Text(" ${purchases[index]['totalAmount']}",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
