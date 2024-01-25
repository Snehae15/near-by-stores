import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:near_by_store/user/User%20cart.dart';
import 'package:near_by_store/user/storeList.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          bottomNavigationBar: Container(
            height: 50.h,
            // width: 330.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xffD5F1E9)),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: const Color(0xff4D6877),
              ),
              tabs: [
                Tab(
                    child: Text(
                  'Store',
                  style: TextStyle(
                    // color: Colors.black87,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.h,
                  ),
                )),
                Tab(
                    child: Text(
                  'Cart',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.h,
                  ),
                ))
              ],
            ),
          ),
          body: const TabBarView(children: [StoreList(), UserCart()])),
    );
  }
}
