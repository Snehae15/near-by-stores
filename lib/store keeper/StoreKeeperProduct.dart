import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:near_by_store/store%20keeper/StoreKeeperAddProduct.dart';

class StoreKeeperProduct extends StatefulWidget {
  final String storeId;

  const StoreKeeperProduct({Key? key, required this.storeId}) : super(key: key);

  @override
  State<StoreKeeperProduct> createState() => _StoreKeeperProductState();
}

class _StoreKeeperProductState extends State<StoreKeeperProduct> {
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('add_product')
          .doc(productId)
          .delete();

      // Show a success message or handle UI update if needed
      Fluttertoast.showToast(
        msg: "Product deleted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print('Error deleting product from Firestore: $e');

      Fluttertoast.showToast(
        msg: "Error deleting product. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "Product List",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
          ),
          Container(
            height: 650.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('add_product')
                  .where('storeId', isEqualTo: widget.storeId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading products"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final productData =
                        products[index].data() as Map<String, dynamic>?;

                    if (productData == null) {
                      return SizedBox.shrink();
                    }

                    return Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 130.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffD5F1E9)),
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
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  productData['imageUrl'] ?? '',
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            productData['name'] ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            "${productData['weight'] ?? ''} ${productData['unit'] ?? ''}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            "Rs. ${productData['price']?.toStringAsFixed(2) ?? ''}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteProduct(products[index].id);
                                      },
                                      icon: Icon(Icons.delete_rounded),
                                    )
                                  ],
                                )
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
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ADDPRoduct(storeId: widget.storeId);
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Add Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: Color(0xff4D6877),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
