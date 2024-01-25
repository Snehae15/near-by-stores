import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/screens/landingpage.dart';

import 'StorekeeperEditProfile.dart';

class STprofile extends StatefulWidget {
  const STprofile({super.key});

  @override
  State<STprofile> createState() => _STprofileState();
}

class _STprofileState extends State<STprofile> {
  late User? _user;
  String _name = '';
  String _email = '';
  String _phonenumber = '';
  String _pincode = '';
  String _address = '';
  String _profileImageUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      await _fetchUserData();
    } else {
      print('User not logged in.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('store_keeper')
          .doc(_user!.uid)
          .get();

      setState(() {
        _name = userSnapshot['name'] ?? '';
        _email = userSnapshot['email'] ?? '';
        _phonenumber = userSnapshot['phonenumber'] ?? '';
        _pincode = userSnapshot['pincode'] ?? '';
        _address = userSnapshot['address'] ?? '';
        _profileImageUrl = userSnapshot['profileImageUrl'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to handle logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoreKeeperEditprofile(),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            )
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: _profileImageUrl.isNotEmpty
                              ? NetworkImage(_profileImageUrl)
                                  as ImageProvider<Object>?
                              : const AssetImage("assets/Ellipse 4.jpg"),
                        ),
                      ),
                      Column(
                        children: [
                          Text("Hey, $_name"),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Container(
                        height: 400.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffD5F1E9),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80.w,
                                    child: const Text(
                                      "Email id",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(":"),
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      _email,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80.w,
                                    child: const Text(
                                      "Phone number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(":"),
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      _phonenumber,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80.w,
                                    child: const Text(
                                      "Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(":"),
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      _address,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                  onPressed: _logout,
                                  child: const Text(
                                    "Log out",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
