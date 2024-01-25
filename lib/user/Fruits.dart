import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/user/user%20product%20details.dart';

class Fruits extends StatefulWidget {
  final String storeName;
  final String storeId;
  final String productId;

  const Fruits({
    Key? key,
    required this.storeName,
    required this.storeId,
    required this.productId,
  }) : super(key: key);

  @override
  State<Fruits> createState() => _FruitsState();
}

class _FruitsState extends State<Fruits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('add_product')
            .where('category', isEqualTo: 'Fruit')
            // .where('storeName', isEqualTo: widget.storeName)
            .where('storeId', isEqualTo: widget.storeId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No Fruits available.');
            return Center(child: Text('No Fruits available.'));
          }

          List<Map<String, dynamic>> groceryData =
              snapshot.data!.docs.map((document) {
            return {
              "id": document.id,
              "name": document['name'],
              "imageUrl": document['imageUrl'],
              "weight": document['weight'],
              "price": document['price'],
            };
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 170,
            ),
            itemCount: groceryData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 10.sp),
                child: InkWell(
                  onTap: () {
                    print("Selected Product ID: ${groceryData[index]["id"]}");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserProductDetails(
                        productId: groceryData[index]["id"],
                      );
                    }));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Color(0xffBBE3D8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          height: 80.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(groceryData[index]["imageUrl"]),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          groceryData[index]["name"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(groceryData[index]["weight"]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.currency_rupee_sharp),
                            Text(
                              groceryData[index]["price"].toString(),
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
