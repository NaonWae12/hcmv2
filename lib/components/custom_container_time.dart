import 'package:flutter/material.dart';

class CustomContainerTime extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final Color? color;

  const CustomContainerTime({
    super.key,
    this.width,
    this.height,
    this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child != null
          ? Align(alignment: Alignment.topLeft, child: child)
          : null,
    );
  }
}
