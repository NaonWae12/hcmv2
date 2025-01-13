// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hcm_3/components/primary_button.dart';
import 'package:hcm_3/service/api_config.dart';

class PagePinSettings1 extends StatefulWidget {
  const PagePinSettings1({super.key});

  @override
  State<PagePinSettings1> createState() => _PagePinSettingsState();
}

class _PagePinSettingsState extends State<PagePinSettings1> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;
  String? _userId; // Menyimpan user_id dari SharedPreferences
  int _currentIndex = 0; // Index untuk mengontrol TextField aktif
  bool _isObscure = true; // Untuk mengontrol visibilitas PIN

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdInt = prefs.getInt("user_id");
    setState(() {
      _userId = userIdInt?.toString();
    });
    print("Loaded user_id: $_userId");
  }

  Future<void> _savePin() async {
    if (_userId == null) {
      setState(() {
        _errorText = "User ID tidak ditemukan! Silakan login kembali.";
      });
      print("Error: User ID is null");
      return;
    }

    String currentPin = _currentPinController.text;
    String newPin = _newPinController.text;
    String confirmPin = _confirmPinController.text;

    if (currentPin.isEmpty) {
      setState(() {
        _errorText = "PIN lama tidak boleh kosong!";
      });
      print("Error: Current PIN is empty");
      return;
    }

    if (newPin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorText = "PIN baru tidak boleh kosong!";
      });
      print("Error: New PIN or Confirm PIN is empty");
      return;
    }

    if (newPin.length < 4 || confirmPin.length < 4) {
      setState(() {
        _errorText = "PIN harus 4 digit atau lebih!";
      });
      print("Error: PIN length is less than 4 digits");
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _errorText = "PIN baru tidak cocok, coba lagi!";
      });
      print("Error: New PIN and Confirm PIN do not match");
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    try {
      var url = Uri.parse("$baseUrl/setup_pin");

      // Menggunakan format x-www-form-urlencoded
      var requestBody = {
        "user_id": _userId!, // String format sesuai kebutuhan API
        "current_pin": currentPin,
        "new_pin": newPin,
      };

      print("Sending request to $url with body: $requestBody");

      var response = await http.post(
        url,
        headers: {
          "Content-Type":
              "application/x-www-form-urlencoded", // Perbaikan di sini
          'api-key': ApiConfig.apiKey,
        },
        body: requestBody,
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PIN berhasil disimpan!")),
          );
        } else {
          setState(() {
            _errorText = responseData['message'] ?? "Terjadi kesalahan!";
          });
          print("Error response: ${responseData['message']}");
        }
      } else {
        setState(() {
          _errorText = "Gagal menyimpan PIN! Coba lagi.";
        });
        print("Error: Non-200 status code received");
      }
    } catch (e) {
      setState(() {
        _errorText = "Terjadi kesalahan: $e";
      });
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onKeyboardTap(String value) {
    List<TextEditingController> controllers = [
      _currentPinController,
      _newPinController,
      _confirmPinController
    ];

    if (_currentIndex < controllers.length) {
      final currentText = controllers[_currentIndex].text;
      if (currentText.length < 4) {
        controllers[_currentIndex].text += value;
      }
      if (controllers[_currentIndex].text.length == 4 &&
          _currentIndex < controllers.length - 1) {
        setState(() {
          _currentIndex += 1;
        });
      }
    }
  }

  void _onBackspace() {
    List<TextEditingController> controllers = [
      _currentPinController,
      _newPinController,
      _confirmPinController
    ];

    if (_currentIndex >= 0) {
      final currentText = controllers[_currentIndex].text;
      if (currentText.isNotEmpty) {
        controllers[_currentIndex].text =
            currentText.substring(0, currentText.length - 1);
      } else if (_currentIndex > 0) {
        setState(() {
          _currentIndex -= 1;
        });
      }
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create New PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: i == 0
                        ? _currentPinController
                        : i == 1
                            ? _newPinController
                            : _confirmPinController,
                    readOnly: true,
                    obscureText: _isObscure,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: i == 0
                          ? "Enter Current PIN"
                          : i == 1
                              ? "Enter New PIN"
                              : "Confirm New PIN",
                      border: const OutlineInputBorder(),
                      counterText:
                          '${i == 0 ? _currentPinController.text.length : i == 1 ? _newPinController.text.length : _confirmPinController.text} / 4', // Menampilkan jumlah karakter yang sudah diinput
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleVisibility, // Toggle visibilitas
                      ),
                    ),
                  ),
                ),
              if (_errorText != null)
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      onPressed: _savePin,
                      buttonText: 'Save PIN',
                    ),
              NumericKeyboard(
                onKeyboardTap: _onKeyboardTap,
                textColor: Colors.black,
                rightButtonFn: _onBackspace,
                rightIcon: const Icon(Icons.backspace, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
