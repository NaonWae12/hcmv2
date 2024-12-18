import 'package:flutter/material.dart';
import 'text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? backgroundColor;
  final double? elevation;
  final BorderSide? side;
  final Widget? child;

  const PrimaryButton({
    super.key,
    this.buttonText,
    required this.onPressed,
    this.buttonWidth,
    this.buttonHeight,
    this.backgroundColor,
    this.elevation,
    this.side,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              Theme.of(context).colorScheme.tertiaryContainer,
          elevation: elevation,
          side: side,
        ),
        child: child ??
            Text(
              buttonText!,
              style: AppTextStyles.heading2_3,
            ),
      ),
    );
  }
}
