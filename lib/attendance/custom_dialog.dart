import 'package:flutter/material.dart';
import '/components/text_style.dart';

Future<void> showCheckInDialog(BuildContext context, String message) async {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Image.asset(
          'assets/thanks3.gif', // Ganti dengan ikon check-in
          height: 80,
        ),
        content: Text(
          message,
          style: AppTextStyles.heading3, // Style body khusus check-in
          overflow: TextOverflow.clip,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: AppTextStyles.heading3, // Style button khusus check-in
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showCheckOutDialog(BuildContext context, String message) async {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Image.asset(
          'assets/clock out.gif', // Ganti dengan ikon check-out
          height: 80,
        ),
        content: Text(
          message,
          style: AppTextStyles.heading3, // Style body khusus check-out
          overflow: TextOverflow.clip,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: AppTextStyles.heading3, // Style button khusus check-out
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showDialog1(BuildContext context, String message) async {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Informasi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
