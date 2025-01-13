// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/payslip/page_detail_payslip.dart';
import '../../service/api_config.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';
import '/components/colors.dart';

class PagePayslipPin1 extends StatefulWidget {
  const PagePayslipPin1({super.key});

  @override
  State<PagePayslipPin1> createState() => _PagePayslipPinState();
}

class _PagePayslipPinState extends State<PagePayslipPin1> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _validatePin() async {
    String pin = _pinController.text;

    if (pin.length < 4) {
      _showDialog("Error", "PIN harus terdiri dari 4 digit.");
      return;
    }

    int? userId = await _getUserId();
    if (userId == null) {
      _showDialog("Error", "User ID tidak ditemukan. Silakan login kembali.");
      return;
    }

    try {
      // Simulasi endpoint API
      var response = await http.post(
        Uri.parse(ApiEndpoints.validatePin()),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'api-key': ApiConfig.apiKey,
        },
        body: {
          'user_id': userId.toString(),
          'pin': pin,
        },
      );

      // Debugging respons API
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        _showDialog("Success", "PIN benar!", isSuccess: true);
      } else {
        _showDialog(
            "Error", data['message'] ?? "PIN salah. Silakan coba lagi.");
      }
    } catch (e) {
      print("Error saat mengirim request: $e");
      _showDialog("Error", "Terjadi kesalahan, silakan coba lagi.");
    }
  }

  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get('user_id');
    if (userId != null) {
      try {
        return int.parse(userId.toString());
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageDetailPayslip(),
                    ),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              'Payslip',
              style: AppTextStyles.heading1_1,
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SvgPicture.asset('assets/icons/payslip_pin.svg'),
            const SizedBox(height: 20),
            Text(
              'Enter PIN',
              style: AppTextStyles.heading1_1,
            ),
            const SizedBox(height: 10),
            Text(
              'For security purposes, before accessing your payslip, you need to enter your PIN',
              style: AppTextStyles.heading3_3,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            /// **Pinput Implementasi**
            Pinput(
              controller: _pinController,
              obscureText: true,
              obscuringCharacter: '•',
              defaultPinTheme: PinTheme(
                height: 72,
                width: 53,
                textStyle: AppTextStyles.displayText_2,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
              length: 4,
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryButton(
                  buttonHeight: 54,
                  buttonWidth: MediaQuery.of(context).size.width / 1.2,
                  buttonText: 'Submit',
                  onPressed: _validatePin,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
