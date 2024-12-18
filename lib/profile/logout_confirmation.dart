import 'package:flutter/material.dart';

class LogoutConfirmation extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmation({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
            onConfirm(); // Panggil fungsi konfirmasi logout
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
