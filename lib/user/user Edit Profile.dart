import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserEditProfile extends StatefulWidget {
  const UserEditProfile({Key? key});

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  late User? _user;
  String _name = '';
  String _email = '';
  String _phonenumber = '';
  String _pincode = '';
  String _address = '';

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
            .collection('users')
            .doc(_user!.uid)
            .get();

        setState(() {
          _email = userSnapshot['email'] ?? '';
          _phonenumber = userSnapshot['phonenumber'] ?? '';
          _pincode = userSnapshot['pincode'] ?? '';
          _address = userSnapshot['address'] ?? '';
          _name = userSnapshot['name'] ?? '';
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({
        'name': _name,
        'email': _email,
        'phonenumber': _phonenumber,
        'pincode': _pincode,
        'address': _address,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error saving changes: $e');
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
        child: Column(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage("assets/Ellipse 4.jpg")
                      as ImageProvider<Object>?,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Center(
                child: Container(
                  height: 550.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffD5F1E9)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTextField("Name", _name, (value) => _name = value,
                            Icons.person),
                        _buildTextField("Email id", _email,
                            (value) => _email = value, Icons.email),
                        _buildTextField("Phone number", _phonenumber,
                            (value) => _phonenumber = value, Icons.phone),
                        _buildTextField("Pin code", _pincode,
                            (value) => _pincode = value, Icons.location_on),
                        _buildTextField("Address", _address,
                            (value) => _address = value, Icons.home),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String value, Function(String) onChanged, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.h),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 290.w,
                  height: 50.h,
                  child: TextFormField(
                    initialValue: value,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: " $label",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(20.sp),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
