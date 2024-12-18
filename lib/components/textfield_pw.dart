import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/text_style.dart';

class TextfileldPw extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final dynamic icon;

  const TextfileldPw({
    super.key,
    required this.hintText,
    this.obscureText = true,
    this.controller,
    this.icon,
  });

  @override
  State<TextfileldPw> createState() => _TextfileldPwState();
}

class _TextfileldPwState extends State<TextfileldPw> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon;

    if (widget.icon is Icon) {
      prefixIcon = widget.icon as Icon;
    } else if (widget.icon is String) {
      prefixIcon = Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          widget.icon, // Path SVG
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
        ),
      );
    }

    return TextField(
      controller: widget.controller,
      style: AppTextStyles.heading2_5,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintStyle: AppTextStyles.heading2,
        hintText: widget.hintText,
        prefixIcon: prefixIcon,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _toggleVisibility,
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
