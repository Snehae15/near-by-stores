import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

              // Check if 'storeId' exists in the order data
              if (orderMap.containsKey('storeId')) {
                // Extract storeId from order data
                final storeId = orderMap['storeId'];
                print('StoreId for order ${orderData.id}: $storeId');

                // Further processing or calling fetchStoreDetails method
                return FutureBuilder(
                  future: fetchStoreDetails(storeId),
                  builder: (context,
                      AsyncSnapshot<Map<String, dynamic>?>
                          storeDetailsSnapshot) {
                    // Widget to display once future is resolved
                  },
                );
              } else {
                print('Error: StoreId not found for order ${orderData.id}');
                return SizedBox();
              }
            },
          );
        },
      ),
    );
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
}
