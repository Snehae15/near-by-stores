import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class STReview extends StatefulWidget {
  const STReview({Key? key});

  @override
  State<STReview> createState() => _STReviewState();
}

class _STReviewState extends State<STReview> {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Review",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: reviewsCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reviews available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return buildReviewItem(snapshot.data!.docs[index]);
            },
          );
        },
      ),
    );
  }

  Widget buildReviewItem(DocumentSnapshot review) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffD5F1E9),
          ),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/Ellipse 4.jpg"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: usersCollection.doc(review['userId']).get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }

                        var name = userSnapshot.data?['name'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reviewer: ${name ?? 'No Name'}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  initialRating: review['rating'] is double
                                      ? review['rating']
                                      : double.parse(
                                          review['rating'].toString()),
                                  itemCount: 5,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Text("(${review['rating']}/5)")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
