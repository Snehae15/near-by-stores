import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/user/user.dart';

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.uid != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('add_cart')
          .where('userId', isEqualTo: user.uid)
          .get();

      final futures = querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] ?? '';

        final productSnapshot = await FirebaseFirestore.instance
            .collection('add_product')
            .doc(productId)
            .get();

        final productData = productSnapshot.data() as Map<String, dynamic>;
        final imageUrl = productData['imageUrl'] ?? '';

        return CartItem(
          id: doc.id,
          name: data['productName'] ?? '',
          weight: '${data['itemCount']} ${data['weightUnit'] ?? 'kg'}',
          price: data['totalPrice'] != null
              ? (data['totalPrice'] as num).toDouble()
              : 0.0,
          imageUrl: imageUrl,
          productId: productId,
          itemCount: data['itemCount'] ?? 0,
          storeId: productData['storeId'] ?? '', // Add storeId to CartItem
        );
      });

      final cartItemsResult = await Future.wait(futures);

      setState(() {
        cartItems = cartItemsResult;
      });
    }
  }

  void submitPurchase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.uid != null) {
      if (cartItems.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Cart is Empty"),
              content: const Text(
                  "Please add items to the cart before confirming the order."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return;
      }

      final purchaseData = await Future.wait(cartItems.map((item) async {
        return {
          'productId': item.productId,
          'productName': item.name,
          'itemCount': item.itemCount,
          'totalPrice': item.price,
          'storeId': item.storeId,
        };
      }));

      final totalAmount = calculateTotalAmount();

      final purchaseCollection =
          FirebaseFirestore.instance.collection('purchases');

      final purchaseDoc = await purchaseCollection.add({
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'totalAmount': totalAmount,
        'items': purchaseData,
        'productId': cartItems.map((item) => item.productId).toList(),
        'storeId': cartItems.map((item) => item.storeId).toList(),
        'productName': cartItems.map((item) => item.name).toList(),
        'itemCount': cartItems.map((item) => item.itemCount).toList(),
      });

      for (final item in cartItems) {
        await FirebaseFirestore.instance
            .collection('add_cart')
            .doc(item.id)
            .delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase successful')),
      );

      setState(() {
        cartItems.clear();
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const UserUser();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                const Text(
                  "    Cart",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                Text(
                  "${cartItems.length} Items in Cart",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            width: 350.w,
            height: 400.h,
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: InkWell(
                    onTap: () {},
                    child: CartItemWidget(
                      cartItem: cartItems[index],
                      onDelete: () {
                        deleteCartItem(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                Text(
                  "Price details",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Price details section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150.h,
                  width: 350.w,
                  color: const Color(0xffCFE9E2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                "Price of (${cartItems.length} items)",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                calculateTotalAmount(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xff4D6877),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: submitPurchase,
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteCartItem(int index) async {
    final item = cartItems[index];

    try {
      await FirebaseFirestore.instance
          .collection('add_cart')
          .doc(item.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted from cart')),
      );
      fetchCartItems();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  String calculateTotalAmount() {
    double totalAmount = 0.0;

    for (final item in cartItems) {
      totalAmount += item.price;
    }

    return "Rs.${totalAmount.toStringAsFixed(2)}";
  }
}

class CartItem {
  final String id;
  final String name;
  final String weight;
  final double price;
  final String imageUrl;
  final String productId;
  final int itemCount;
  final String storeId; // Add storeId to CartItem

  CartItem({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    required this.imageUrl,
    required this.productId,
    required this.itemCount,
    required this.storeId,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onDelete;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffD5F1E9),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(cartItem.imageUrl),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          cartItem.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          cartItem.weight,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Rs.${cartItem.price}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: 3,
                              itemCount: 5,
                              itemSize: 15,
                              direction: Axis.horizontal,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
