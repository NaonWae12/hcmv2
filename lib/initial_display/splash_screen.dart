import 'dart:async';

import 'package:flutter/material.dart';
import '/components/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController?.forward();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                  parent: _animationController!, curve: Curves.easeOut)),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/2.jpg',
                      height: 250,
                      width: 250,
                    ),
                    Text(
                      'PT. Jakarana Tama',
                      style: AppTextStyles.displayText_3(context),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
