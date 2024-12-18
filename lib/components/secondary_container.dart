import 'package:flutter/material.dart';

class SecondaryContainer extends StatelessWidget {
  final double width;
  final double? height;
  final Widget? child;

  const SecondaryContainer({
    super.key,
    required this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child != null
          ? Align(alignment: Alignment.topLeft, child: child)
          : null,
    );
  }
}
