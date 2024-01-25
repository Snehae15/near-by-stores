import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreKeeperOrder extends StatefulWidget {
  const StoreKeeperOrder({
    Key? key,
    required this.totalAmount,
    required this.userId,
    required this.purchaseId,
  }) : super(key: key);

  final String totalAmount;
  final String userId;
  final String purchaseId;

  @override
  State<StoreKeeperOrder> createState() => _StoreKeeperOrderState();
}

class _StoreKeeperOrderState extends State<StoreKeeperOrder> {
  var order = ["Packing", "Packed"];
  String dropdownOrder = 'Packing';
  String name = '';
  List<Product> productList = [];
  String selectedStatus = 'Packing';

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchPurchasedItems();
  }

  Future<void> fetchUserName() async {
    try {
      if (widget.userId.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .get();

        if (userSnapshot.exists) {
          setState(() {
            name = userSnapshot['name'];
          });
        } else {
          print('User document not found for userId: ${widget.userId}');
        }
      } else {
        print('Invalid userId: ${widget.userId}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchPurchasedItems() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> purchaseSnapshot =
          await FirebaseFirestore.instance
              .collection('purchases')
              .doc(widget.purchaseId)
              .get();

      if (purchaseSnapshot.exists && purchaseSnapshot.data() != null) {
        List<Product> products = (purchaseSnapshot.data()!['items'] as List)
            .map((item) => Product(
                  productName: item['productName'] ?? '',
                  itemCount: item['itemCount']?.toString() ?? '',
                  totalPrice: item['totalPrice']?.toString() ?? '',
                ))
            .toList();

        setState(() {
          productList = products;
        });
      } else {
        print(
            'Purchase document not found for purchaseId: ${widget.purchaseId}');
      }
    } catch (e) {
      print('Error fetching purchased items: $e');
    }
  }

  Future<void> updateStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('purchases')
          .doc(widget.purchaseId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to: $status'),
        ),
      );
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 10.sp),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Order view",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70.h,
            width: 340.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffD5F1E9),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/Ellipse 4.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(name),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.currency_rupee),
                    ),
                    Text(widget.totalAmount),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300.w,
                  height: 50.h,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Select Status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 75.0),
                        child: DropdownButton(
                          focusColor: const Color.fromARGB(255, 29, 82, 126),
                          dropdownColor: Colors.black26,
                          iconEnabledColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          value: dropdownOrder,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: order.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownOrder = newValue!;
                              selectedStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: Color(0xff4D6877),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.sp),
            child: Row(
              children: [
                Text("Lists", style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            height: 450.h,
            width: 340.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffD5F1E9),
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: productList.isEmpty
                        ? Text('No data available.')
                        : Column(
                            children: productList.map((product) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xffDEFFF6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Count: ${product.itemCount}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      'Price: ${product.totalPrice}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300.w,
                      height: 50.h,
                      child: TextButton(
                        onPressed: () {
                          updateStatus(selectedStatus);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.sp),
                        color: Color(0xff4D6877),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String productName;
  final String itemCount;
  final String totalPrice;

  Product({
    required this.productName,
    required this.itemCount,
    required this.totalPrice,
  });
}
