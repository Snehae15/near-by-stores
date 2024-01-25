import 'dart:async';

import 'package:flutter/material.dart';
import 'package:near_by_store/screens/landingpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({
    super.key,
  });

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFCFE9E2),
              Colors.white,
            ],
          ),
        ),
      ),
    );
  }
}
