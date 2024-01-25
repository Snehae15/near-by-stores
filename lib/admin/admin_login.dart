import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/admin/admin%20home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({
    super.key,
  });

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  void _login() {
    const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'Admin@123';

    if (_emailController.text == adminEmail &&
        _passwordController.text == adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
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
                    " Email",
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
                    width: 290.w,
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
                        hintText: "  Enter email",
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
                    width: 290.w,
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
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
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
                      onPressed: _login,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.w),
                          const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
}
