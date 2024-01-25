import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:near_by_store/store%20keeper/store%20keeper%20login.dart';

class StorekeeperRegister extends StatefulWidget {
  const StorekeeperRegister({super.key});

  @override
  _StorekeeperRegisterState createState() => _StorekeeperRegisterState();
}

class _StorekeeperRegisterState extends State<StorekeeperRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/store 1.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    20,
                  ),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter name",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    " Email id",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter email id",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    " Phone number",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _phonenumberController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter Phone number",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    " Pincode",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 290,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _pincodeController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter pincode",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    " Address",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter address",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 190,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff4D6877),
                ),
                child: TextButton(
                  onPressed: () {
                    register();
                  },
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    try {
      // Validation checks
      if (_phonenumberController.text.length != 10) {
        showToast("Please enter a valid 10-digit phone number.");
        return;
      }

      if (_pincodeController.text.length != 6) {
        showToast("Please enter a valid 6-digit pincode.");
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('store_keeper').doc(uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phonenumber': _phonenumberController.text,
        'pincode': _pincodeController.text,
        'address': _addressController.text,
        'password': _passwordController.text,
        'userId': uid,
      });

      // Call Cloud Function to send confirmation email
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      showToast("Registration successful! Confirmation email sent.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StorekeeperLogin(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast("The account already exists for that email.");
      } else {
        showToast("Error: ${e.message}");
      }
    } catch (e) {
      showToast("Error: $e");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
