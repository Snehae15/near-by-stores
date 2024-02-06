import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUser extends StatelessWidget {
  Future<void> _updateUserStatus(String userId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error fetching users: ${snapshot.error}');
            return const Center(
              child: Text('Error loading users'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;

              return UserCard(
                userId: users[index].id,
                name: userData['name'] ?? '',
                address: userData['address'] ?? '',
                pincode: userData['pincode'] ?? '',
                phonenumber: userData['phonenumber'] ?? '',
                status: userData['status'] ?? '',
                onAccept: () {
                  _updateUserStatus(users[index].id, 'Accepted');
                },
                onReject: () {
                  _updateUserStatus(users[index].id, 'Rejected');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userId;
  final String name;
  final String address;
  final String pincode;
  final String phonenumber;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const UserCard({
    required this.userId,
    required this.name,
    required this.address,
    required this.pincode,
    required this.phonenumber,
    required this.status,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 40,
          backgroundImage: const AssetImage("assets/Ellipse 4.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Container(
            height: 630,
            width: 390,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Color(0xffD5F1E9),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      address,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pin : $pincode",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        phonenumber,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        onAccept();
                      },
                      child: const Text(
                        "Accept",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        onReject();
                      },
                      child: const Text(
                        "Reject",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                if (status.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'User has been $status',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
