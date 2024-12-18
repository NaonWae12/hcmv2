import 'package:flutter/material.dart';

Future<void> showSuccessDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // Dialog tidak bisa ditutup dengan mengetuk di luar
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
