import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/user/UserOrderList.dart';
import 'package:near_by_store/user/user%20Profile.dart';
import 'package:near_by_store/user/user_Store_details.dart';

class StoreList extends StatefulWidget {
  const StoreList({Key? key});

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  late Stream<QuerySnapshot> _storesStream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storesStream =
        FirebaseFirestore.instance.collection('add_store').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Near By stores",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const UserOrderList();
                        }));
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const UserProfile();
                        }));
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("assets/Ellipse 4.jpg"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50.h,
                width: 330.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xffDDEEE9),
                ),
                child: Row(children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(
                    width: 200.w,
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        _onSearchChanged(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "      Search store by Pincode",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _storesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final stores = snapshot.data?.docs ?? [];

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final storeData =
                        stores[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: EdgeInsets.only(left: 10.sp),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserStoreDetails(
                                  storeId: storeData['storeId'],
                                  storeName: storeData['name'],
                                  storeImageURL: storeData['storeImageURL'],
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffBBE3D8),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                height: 110.h,
                                width: 150.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        storeData['storeImageURL'] ?? ''),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                storeData['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(storeData['category'] ?? ''),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: storeData['rating'] ?? 0,
                                      itemCount: 5,
                                      itemSize: 15,
                                      direction: Axis.horizontal,
                                      itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                              ),
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

  void _onSearchChanged(String query) {
    setState(() {
      _storesStream = FirebaseFirestore.instance
          .collection('add_store')
          .where('pincode', isGreaterThanOrEqualTo: query)
          .where('pincode', isLessThan: query + 'z')
          .snapshots();
    });
  }
}
