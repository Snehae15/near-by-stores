import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/screens/landingpage.dart';
import 'package:near_by_store/user/user%20Edit%20Profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  late UserData _userData;

  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();

    _user = _auth.currentUser;
    _userData =
        UserData(name: "", email: _user?.email ?? "", pincode: "", address: "");
    _userDataFuture = fetchUserData();
  }

  Future<DocumentSnapshot> fetchUserData() {
    return _firestore.collection('users').doc(_user?.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/Ellipse 4.jpg"),
                  ),
                ],
              ),
              // IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
              Text(
                "Hey, ${_userData.name}",
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Container(
              height: 400.h,
              width: 350.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffD5F1E9),
              ),
              child: FutureBuilder(
                future: _userDataFuture,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    _userData = UserData.fromSnapshot(snapshot.data!);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const UserEditProfile();
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        buildProfileItem("Name", _userData.name),
                        buildProfileItem("Email id", _userData.email),
                        buildProfileItem("Pincode", _userData.pincode),
                        buildProfileItem("Address", _userData.address),
                        Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Container(
                            height: 40.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff4D6877),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _auth.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Log out",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(":"),
          ),
          SizedBox(
            width: 200.w,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class UserData {
  final String name;
  final String email;
  final String pincode;
  final String address;

  UserData({
    required this.name,
    required this.email,
    required this.pincode,
    required this.address,
  });

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        pincode = snapshot['pincode'] ?? '',
        address = snapshot['address'] ?? '';
}
