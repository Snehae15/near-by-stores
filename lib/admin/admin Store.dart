import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminStore extends StatefulWidget {
  final String userId;

  const AdminStore({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminStore> createState() => _AdminStoreState();
}

class _AdminStoreState extends State<AdminStore> {
  String name = "";
  String category = "";
  String address = "";
  String pincode = "";

  @override
  void initState() {
    super.initState();
    // Fetch store details when the widget is initialized
    _fetchStoreDetails();
  }

  Future<void> _fetchStoreDetails() async {
    try {
      // Fetch store details based on userId from Firebase
      var snapshot = await FirebaseFirestore.instance
          .collection('add_store')
          .where('userId', isEqualTo: widget.userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var storeData = snapshot.docs[0].data() as Map<String, dynamic>;

        setState(() {
          name = storeData['name'] ?? "";
          category = storeData['category'] ?? "";
          address = storeData['address'] ?? "";
          pincode = storeData['pincode'] ?? "";
        });
      }
    } catch (e) {
      print('Error fetching store details: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_rounded),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/Rectangle 32.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Container(
                height: 605.h,
                width: 390.w,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xffD5F1E9),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          address,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " $pincode",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 300.h, bottom: 10.h),
                      child: Container(
                        height: 40.h,
                        width: 300.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40.h,
                        width: 300.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
