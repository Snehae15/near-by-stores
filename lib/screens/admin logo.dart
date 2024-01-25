import 'package:flutter/material.dart';

class AdminLogo extends StatefulWidget {
  const AdminLogo({super.key});

  @override
  State<AdminLogo> createState() => _AdminLogoState();
}

class _AdminLogoState extends State<AdminLogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/admin logo.jpg"), fit: BoxFit.fill))),
    );
  }
}
