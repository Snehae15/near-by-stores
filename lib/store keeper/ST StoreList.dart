import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'StoreKeeperAddStore.dart';
import 'StoreKeeperProduct.dart';

class StStoreList extends StatefulWidget {
  const StStoreList({
    super.key,
  });

  @override
  State<StStoreList> createState() => _StStoreListState();
}

class _StStoreListState extends State<StStoreList> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Added Store",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 650.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('add_store')
                  .where('userId', isEqualTo: _user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading stores"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final stores = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final storeData =
                        stores[index].data() as Map<String, dynamic>;
                    final storeId = stores[index].id;

                    return Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StoreKeeperProduct(storeId: storeId);
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 120.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xffD5F1E9)),
                          child: Row(
                            children: [
                              Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 100.w,
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        storeData[
                                                            'storeImageURL']),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(storeData['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _deleteStore(stores[index].reference);
                                      },
                                      icon: const Icon(Icons.delete_rounded),
                                    )
                                  ],
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300.w,
                height: 50.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: const Color(0xff4D6877)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const StoreKeeperAddStore();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Add Store",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Function to delete store from Firestore
  void _deleteStore(DocumentReference documentReference) {
    documentReference.delete().then((value) {
      print("Store deleted successfully");
    }).catchError((error) {
      print("Failed to delete store: $error");
    });
  }
}
