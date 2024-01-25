import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class StoreKeeperEditprofile extends StatefulWidget {
  const StoreKeeperEditprofile({Key? key}) : super(key: key);

  @override
  State<StoreKeeperEditprofile> createState() => _StoreKeeperEditprofileState();
}

class _StoreKeeperEditprofileState extends State<StoreKeeperEditprofile> {
  late User? _user;
  File? _image;
  String _email = '';
  String _phonenumber = '';
  String _pincode = '';
  String _address = '';
  String _profileImageUrl = '';

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('store_keeper')
            .doc(_user!.uid)
            .get();

        setState(() {
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
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      // Save image to Firebase Storage
      String imageUrl =
          _profileImageUrl; // Default to the current profile image URL

      if (_image != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('Storeprofile_images/${_user!.uid}');
        await storageReference.putFile(_image!);
        imageUrl = await storageReference.getDownloadURL();
      }

      // Update user data in Firestore
      await FirebaseFirestore.instance
          .collection('store_keeper')
          .doc(_user!.uid)
          .update({
        'email': _email,
        'phonenumber': _phonenumber,
        'pincode': _pincode,
        'address': _address,
        'profileImageUrl': imageUrl, // Update the profile image URL
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
        ),
      );

      // If you want to update the local state with the new profile image URL
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      print('Error saving changes: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Profile"),
            IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                              as ImageProvider<Object>?
                          : const AssetImage("assets/Ellipse 4.jpg")
                              as ImageProvider<Object>?,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Center(
              child: Container(
                height: 500.h,
                width: 350.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffD5F1E9)),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50.w, top: 50.h),
                      child: const Row(
                        children: [
                          Text(
                            "Email id",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290.w,
                            height: 50.h,
                            child: TextFormField(
                              initialValue: _email,
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter emaild id",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(20.sp),
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: const Row(
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290.w,
                            height: 50.h,
                            child: TextFormField(
                              initialValue: _phonenumber,
                              onChanged: (value) {
                                setState(() {
                                  _phonenumber = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter password",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(20.sp),
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: const Row(
                        children: [
                          Text(
                            "Pin code",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290.w,
                            height: 50.h,
                            child: TextFormField(
                              initialValue: _pincode,
                              onChanged: (value) {
                                setState(() {
                                  _pincode = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter pincode",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(20.sp),
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: const Row(
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290.w,
                            height: 50.h,
                            child: TextFormField(
                              initialValue: _address,
                              onChanged: (value) {
                                setState(() {
                                  _address = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter address",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(20.sp),
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
