// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';
import 'page_detail_payslip.dart';

class PagePayslipPin extends StatefulWidget {
  const PagePayslipPin({super.key});

  @override
  State<PagePayslipPin> createState() => _PagePayslipPinState();
}

class _PagePayslipPinState extends State<PagePayslipPin> {
  // Menyimpan TextEditingController dan String untuk tiap input PIN
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<String> _pin = List.generate(4, (_) => '');

  @override
  void dispose() {
    // Membersihkan controller ketika widget tidak lagi digunakan
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Menyimpan input pin di dalam list
      _pin[index] = value;

      // Mengatur timer untuk mengubah karakter menjadi titik setelah beberapa milidetik
      Timer(const Duration(milliseconds: 500), () {
        _controllers[index].text = '•';
      });

      // Pindah fokus ke kotak input berikutnya jika sudah terisi
      if (index < 3) {
        FocusScope.of(context).nextFocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Jika input dihapus, pindah ke kotak input sebelumnya
      FocusScope.of(context).previousFocus();
    }
  }

  Future<void> _validatePin() async {
    String pin = _pin.join();

    if (pin.length < 4) {
      _showDialog("Error", "PIN harus terdiri dari 4 digit.");
      return;
    }

    int? userId = await _getUserId();
    if (userId == null) {
      _showDialog("Error", "User ID tidak ditemukan. Silakan login kembali.");
      return;
    }

    // LOG: Menampilkan User ID dan PIN sebelum dikirim
    print("User ID: $userId");
    print("PIN: $pin");
    print("Request Body: {'user_id': $userId, 'pin': $pin}");

    try {
      var response = await http.post(
        Uri.parse(ApiEndpoints.validatePin()),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'api-key': ApiConfig.apiKey,
        },
        body: {
          'user_id':
              userId.toString(), // Gunakan format key-value, bukan JSON string
          'pin': pin,
        },
      );

      // LOG: Menampilkan respons API
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Periksa apakah respons status adalah 'success'
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        _showDialog("Success", "PIN benar!", isSuccess: true);
      } else {
        _showDialog("Error", "PIN salah. Silakan coba lagi.");
      }
    } catch (e) {
      print("Error saat mengirim request: $e"); // LOG: Menampilkan error
      _showDialog("Error", "Terjadi kesalahan, silakan coba lagi.");
    }
  }

  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get('user_id'); // Dapatkan user_id tanpa tipe spesifik

    if (userId != null) {
      try {
        return int.parse(userId.toString()); // Konversi ke int
      } catch (e) {
        print("Error saat mengonversi user_id ke int: $e");
        return null; // Jika gagal dikonversi, kembalikan null
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
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    height: 72,
                    width: 53,
                    child: TextFormField(
                      controller: _controllers[index],
                      onChanged: (value) => _onChanged(index, value),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      style: AppTextStyles.displayText_2,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
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
