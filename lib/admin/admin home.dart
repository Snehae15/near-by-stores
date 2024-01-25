import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/screens/landingpage.dart';

import 'admin home Store List.dart';
import 'admin home user List.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Function to handle logout
  void _logout() {
    // Navigate to the LandingPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Admin Home')),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Container(
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xffD5F1E9),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xff4D6877),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.h,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Store',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(child: const TabBarView(children: [User(), Store()])),
      ),
    );
  }
}
