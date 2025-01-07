// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PagePinSettings extends StatefulWidget {
  const PagePinSettings({super.key});

  @override
  State<PagePinSettings> createState() => _PagePinSettingsState();
}

class _PagePinSettingsState extends State<PagePinSettings> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;
  String? _userId; // Menyimpan user_id dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Panggil fungsi untuk mengambil user_id
  }

  /// Mengambil user_id dari SharedPreferences
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Coba ambil user_id sebagai integer
    int? userIdInt = prefs.getInt("user_id");

    // Jika user_id disimpan sebagai integer, ubah ke string
    setState(() {
      _userId = userIdInt?.toString();
    });
    print("Loaded user_id: $_userId"); // Log user_id
  }

  /// Mengirim PIN ke API
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
      var url = Uri.parse("https://jt-hcm.simise.id/api/setup_pin");

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
          'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
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
              TextField(
                controller: _currentPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: "Enter Current PIN",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: "Enter New PIN",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: "Confirm New PIN",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorText != null)
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _savePin,
                      child: const Text("Save PIN"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
