import 'package:flutter/material.dart';

class PrimaryContainer extends StatelessWidget {
  final double width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? color;

  const PrimaryContainer({
    super.key,
    required this.width,
    this.height,
    this.child,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: borderRadius ?? BorderRadius.circular(15),
      ),
      child: child != null
          ? Align(alignment: Alignment.topLeft, child: child)
          : null,
    );
  }
}
