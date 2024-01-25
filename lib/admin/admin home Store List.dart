import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/admin/admin%20Store.dart';

class Store extends StatefulWidget {
  const Store({Key? key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 650.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('add_store')
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
                    return Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminStore(
                                userId: storeData['userId'],
                              ),
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
                                          const Text('Item',
                                              style: TextStyle(
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
