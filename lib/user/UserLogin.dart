import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:near_by_store/user/UserHome.dart';
import 'package:near_by_store/user/UserRegister.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({
    super.key,
  });

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140.h,
                      width: 140.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/store 1.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
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
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.w),
              child: Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                    width: 300.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20.sp),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter email-id",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.w, top: 30.h),
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      " Password",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.sp),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "  Enter Password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20.sp,
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
            Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 190.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.sp),
                      color: const Color(0xff4D6877),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        // Access the entered email and password using _emailController.text and _passwordController.text
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (userCredential.user != null) {
                            // User is logged in
                            print("Login successful");

                            // You can add additional checks here if needed
                            // For example, check if the user is an admin or has certain permissions

                            Fluttertoast.showToast(
                              msg: "Login successful",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserHome(),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle login errors
                          print("Login failed: $e");
                          Fluttertoast.showToast(
                            msg: "Login failed. Check your credentials.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserRegister(),
                  ),
                );
              },
              child: const Text(
                "Sign up",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
