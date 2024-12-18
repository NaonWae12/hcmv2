import 'package:flutter/material.dart';

class DialogUtils {
  /// Menampilkan dialog kesalahan
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Attention'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Menampilkan dialog sukses
  static void showSuccessDialog(BuildContext context, String message,
      {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sukses'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
              if (onOkPressed != null) {
                onOkPressed(); // Jalankan callback jika disediakan
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
