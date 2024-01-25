import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/user/User%20cart.dart';

class UserProductDetails extends StatefulWidget {
  final String productId;

  const UserProductDetails({Key? key, required this.productId})
      : super(key: key);

  @override
  State<UserProductDetails> createState() => _UserProductDetailsState();
}

class _UserProductDetailsState extends State<UserProductDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> productStream;
  int itemCount = 1;
  int availableStock = 0;

  @override
  void initState() {
    super.initState();
    productStream = FirebaseFirestore.instance
        .collection('add_product')
        .doc(widget.productId)
        .snapshots();
  }

  Future<void> addToCart() async {
    final productDataSnapshot = await FirebaseFirestore.instance
        .collection('add_product')
        .doc(widget.productId)
        .get();

    if (!productDataSnapshot.exists) {
      // Handle the case where the document doesn't exist.
      return;
    }

    final user = _auth.currentUser;
    if (user == null || user.uid == null) {
      // Handle the case where the user is not logged in or UID is null.
      return;
    }

    final productData = productDataSnapshot.data() as Map<String, dynamic>;
    final stock = (productData['stock'] ?? 0).toInt(); // Ensure stock is an int
    final price =
        (productData['price'] ?? 0.0).toDouble(); // Ensure price is a double

    if (stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product out of stock')),
      );
      return;
    }

    if (price is num) {
      if (itemCount > stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected quantity exceeds stock')),
        );
        return;
      }

      final totalPrice = itemCount * (price as num).toDouble();

      final updatedStock = stock - itemCount;

      await FirebaseFirestore.instance
          .collection('add_product')
          .doc(widget.productId)
          .update({'stock': updatedStock});

      await FirebaseFirestore.instance.collection('add_cart').add({
        'productId': widget.productId,
        'productName': productData['name'],
        'itemCount': itemCount,
        'totalPrice': totalPrice,
        'userId': user.uid,
        'storeId': productData['storeId'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );

      final cartItemsSnapshot = await FirebaseFirestore.instance
          .collection('add_cart')
          .where('productId', isEqualTo: widget.productId)
          .get();

      final cartItems =
          cartItemsSnapshot.docs.map((doc) => doc.data()).toList();

      print('Cart Items: $cartItems');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserCart(),
        ),
      );
    } else {
      print('Error: Price is not a numeric value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: productStream,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found.'));
          }

          final productData = snapshot.data!.data();

          availableStock = (productData?['stock'] ?? 0).toInt();

          final weight = (productData?['weight']) ?? 'Weight not available';
          final price = (productData?['price'] ?? 0.0)
              .toDouble(); // Ensure price is a double

          return Column(
            children: [
              SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text(
                      "Product",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200.h,
                    width: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                            productData?['imageUrl'] as String? ?? ''),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productData?['name'] as String? ?? 'Product Name',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(weight),
                    Text(
                      ' $price',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffD5F1E9),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Color(0xff4D6877),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (itemCount > 1) {
                                  setState(() {
                                    itemCount--;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.remove_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                            child: Center(
                              child: Text(
                                itemCount.toString(),
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: Color(0xff4D6877),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  itemCount++;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffD5F1E9),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Color(0xffD5F1E9),
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                            child: Center(
                              child: Text(
                                "kg",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: Color(0xff4D6877),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 330.w,
                  height: 300.h,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Available Stock: $availableStock',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '..................................................................................'),
                      Text(
                        productData?['description'] as String? ??
                            'Product Description',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50.h,
                width: 330.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff4D6877),
                ),
                child: TextButton(
                  onPressed: () {
                    addToCart();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
