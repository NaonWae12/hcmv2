// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final String imagePath;
  const CustomLoading({super.key, required this.imagePath});

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _rotationAnimation,
        child: Image.asset(
          widget.imagePath,
          width: 100, // Ukuran gambar bisa disesuaikan
          height: 100,
        ),
      ),
    );
  }
}
