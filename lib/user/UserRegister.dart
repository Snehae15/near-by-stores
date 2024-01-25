import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'UserLogin.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({
    super.key,
  });

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _passwordVisible = false;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140.0,
                      width: 140.0,
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
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
              ],
            ),
            buildTextField(
              "Name",
              nameController,
              TextInputType.text,
              Icons.person,
              false,
            ),
            buildTextField(
              "Email id",
              emailController,
              TextInputType.emailAddress,
              Icons.email,
              false,
            ),
            buildTextField(
              "Password",
              passwordController,
              TextInputType.visiblePassword,
              Icons.lock,
              true,
            ),
            buildTextField(
              "Pincode",
              pincodeController,
              TextInputType.number,
              Icons.location_pin,
              false,
            ),
            buildTextField(
              "Address",
              addressController,
              TextInputType.streetAddress,
              Icons.location_on,
              false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 190.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xff4D6877),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Validate the form fields
                        if (_validateForm()) {
                          // Register the user
                          _registerUser();
                        }
                      },
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    TextEditingController controller,
    TextInputType keyboardType,
    IconData icon,
    bool isPassword,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300.0,
                  height: 50.0,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: isPassword && !_passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "  Enter $labelText",
                      prefixIcon: Icon(icon),
                      suffixIcon: isPassword
                          ? IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "$labelText is required";
                      }
                      if (labelText == "Email id" &&
                          !_isValidEmail(value.trim())) {
                        return "Invalid email format";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        addressController.text.isEmpty) {
      _showSnackBar("All fields are required");
      return false;
    }

    if (!_isValidEmail(emailController.text)) {
      _showSnackBar("Invalid email format");
      return false;
    }

    return true;
  }

  Future<void> _registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Save additional user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'pincode': pincodeController.text,
        'address': addressController.text,
        'password': passwordController.text,
        'userId': uid,
      });

      print('User registered successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserLogin(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to register user: $e');
      String errorMessage = "Registration failed. ${e.message}";

      if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already in use. Please use a different email.";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Unexpected error during registration: $e');
      Fluttertoast.showToast(
        msg: "Unexpected error during registration.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
