import 'package:flutter/material.dart';
import 'package:near_by_store/admin/admin_login.dart';
import 'package:near_by_store/store%20keeper/store%20keeper%20login.dart';
import 'package:near_by_store/user/UserLogin.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCFE9E2),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLogin(),
                ),
              );
            },
            child: const Text(
              'Administrator Login',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 16), // Adjust the spacing as needed
        ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.8,
                      child: Image.asset('assets/store 1.jpg'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Select User Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: SizedBox(height: 35),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserLogin(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFCFE9E2),
                                    Color(0xFFCFE9E2),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: screenWidth * 0.35,
                              height: 40,
                              child: const Center(
                                child: Text(
                                  'User',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StorekeeperLogin(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFCFE9E2),
                                    Color(0xFFCFE9E2),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: screenWidth * 0.35,
                              height: 40,
                              child: const Center(
                                child: Text(
                                  'Store keeper',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]);
          },
        ),
      ),
    );
  }
}
