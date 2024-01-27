import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ST OrderList.dart';
import 'ST Profile.dart';
import 'ST StoreList.dart';
import 'STReview.dart';

class StorekeeeperOrderView extends StatefulWidget {
  const StorekeeeperOrderView({Key? key, required String userId})
      : super(key: key);

  @override
  State<StorekeeeperOrderView> createState() => _StorekeeeperOrderViewState();
}

class _StorekeeeperOrderViewState extends State<StorekeeeperOrderView> {
  final String userId = '';
  final double totalAmount = 0.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xffD5F1E9),
          ),
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
                  'Order',
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
              Tab(
                child: Text(
                  'Review',
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
                  'Profile',
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  StorekeepOrderList(),
                  StStoreList(),
                  STReview(),
                  STprofile(),
                ],
              ),
      ),
    );
  }
}
