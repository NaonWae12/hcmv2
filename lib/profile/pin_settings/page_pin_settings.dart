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
  final TextEditingController _pinController = TextEditingController();
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
  }

  /// Mengirim PIN ke API
  Future<void> _savePin() async {
    if (_userId == null) {
      setState(() {
        _errorText = "User ID tidak ditemukan! Silakan login kembali.";
      });
      return;
    }

    String pin = _pinController.text;
    String confirmPin = _confirmPinController.text;

    if (pin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorText = "PIN tidak boleh kosong!";
      });
      return;
    }

    if (pin.length < 4 || confirmPin.length < 4) {
      setState(() {
        _errorText = "PIN harus 4 digit atau lebih!";
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        _errorText = "PIN tidak cocok, coba lagi!";
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    try {
      var url = Uri.parse("https://jt-hcm.simise.id/api/validate_pin");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": _userId, // Kirim user_id dari SharedPreferences
          "pin": pin
        }),
      );

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
        }
      } else {
        setState(() {
          _errorText = "Gagal menyimpan PIN! Coba lagi.";
        });
      }
    } catch (e) {
      setState(() {
        _errorText = "Terjadi kesalahan: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Masukkan PIN baru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: "Enter PIN",
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
                labelText: "Confirm PIN",
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
    );
  }
}
