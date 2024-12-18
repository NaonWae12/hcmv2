import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/text_style.dart';

class TextfieldInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final dynamic icon;
  final BorderSide? borderSide;
  final Color? svgColor;

  const TextfieldInput({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.icon,
    this.borderSide,
    this.svgColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon;

    if (icon is Icon) {
      prefixIcon = icon as Icon;
    } else if (icon is String) {
      prefixIcon = Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          icon, // Path SVG
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
          colorFilter: svgColor != null
              ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
              : null, // Menggunakan colorFilter
        ),
      );
    }

    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      style: AppTextStyles.heading2_5,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintStyle: AppTextStyles.heading2,
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ?? BorderSide.none,
          )),
    );
  }
}
