// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'page_detail_payslip.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final int userId = 13; // ID user statis untuk contoh
  String _responseMessage = "";

  Future<void> validatePin() async {
    final url = Uri.parse('https://jt-hcm.simise.id/api/validate_pin');
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };

    final body = {
      'user_id': userId.toString(), // User ID sebagai string
      'pin': _pinController.text,
    };

    try {
      print("Sending request to $url");
      print("Headers: $headers");
      print("Body: $body");

      // Encode body as x-www-form-urlencoded
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageDetailPayslip(),
            ),
          );
        } else {
          setState(() {
            _responseMessage = data['message'];
          });
        }
      } else {
        setState(() {
          _responseMessage =
              "Error: ${response.statusCode}. Detail: ${response.body}";
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        _responseMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masukkan PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masukkan PIN Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PIN',
                hintText: 'Masukkan 4 digit PIN',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: validatePin,
              child: Text('Validasi PIN'),
            ),
            SizedBox(height: 16),
            Text(
              _responseMessage,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
