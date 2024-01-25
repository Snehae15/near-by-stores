import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/admin/admin%20user.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text("User"),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              var documentId = user.id; // get the document id
              var name = user['name'];
              var phonenumber = user['phonenumber'];

              return Padding(
                padding: EdgeInsets.all(10.sp),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AdminUser();
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 100.h,
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
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage("assets/Ellipse 4.jpg"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(name),
                                      Text(phonenumber),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle delete action
                                    _deleteUser(documentId);
                                  },
                                  icon: const Icon(Icons.delete_rounded),
                                )
                              ],
                            )
                          ],
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
    );
  }

  // Function to delete user from Firebase
  void _deleteUser(String documentId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .delete();
    // Optionally, you can add a feedback or handle the deletion completion.
  }
}
