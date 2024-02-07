import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreKeeperEditprofile extends StatefulWidget {
  const StoreKeeperEditprofile({Key? key}) : super(key: key);

  @override
  State<StoreKeeperEditprofile> createState() => _StoreKeeperEditprofileState();
}

class _StoreKeeperEditprofileState extends State<StoreKeeperEditprofile> {
  late User? _user;
  String _name = '';
  String _email = '';
  String _phonenumber = '';
  String _address = '';
  String _pincode = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('store_keeper')
            .doc(_user!.uid)
            .get();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
          _email = userSnapshot['email'] ??
              prefs.getString('store_keeper_email') ??
              '';
          _phonenumber = userSnapshot['phonenumber'] ??
              prefs.getString('store_keeper_phonenumber') ??
              '';
          _pincode = userSnapshot['pincode'] ??
              prefs.getString('store_keeper_pincode') ??
              '';
          _address = userSnapshot['address'] ??
              prefs.getString('store_keeper_address') ??
              '';
          _name = userSnapshot['name'] ??
              prefs.getString('store_keeper_name') ??
              '';
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('store_keeper')
          .doc(_user!.uid)
          .update({
        'name': _name,
        'email': _email,
        'phonenumber': _phonenumber,
        'address': _address,
        'pincode': _pincode,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('store_keeper_email', _email);
      prefs.setString('store_keeper_phonenumber', _phonenumber);
      prefs.setString('store_keeper_address', _address);
      prefs.setString('store_keeper_name', _name);
      prefs.setString('store_keeper_pincode', _pincode);

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
                        _buildTextField(
                            "Pincode",
                            _pincode,
                            (value) => _pincode = value,
                            Icons.home_repair_service),
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
                      hintStyle: TextStyle(color: Colors.black),
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
