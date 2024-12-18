import 'package:flutter/material.dart';

class CustomChoiceContainer extends StatelessWidget {
  final double width;
  final double? height;
  final Widget? child;
  final Color? color;

  const CustomChoiceContainer({
    super.key,
    required this.width,
    this.height,
    this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child != null
          ? Align(alignment: Alignment.topLeft, child: child)
          : null,
    );
  }
}
