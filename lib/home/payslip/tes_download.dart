// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PayslipScreenState createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  bool _isDownloading = false;

  Future<void> downloadAndOpenPayslip() async {
    setState(() => _isDownloading = true);

    const String url = "$baseUrl/payslip/download/66";
    final Map<String, String> headers = {
      "api-key": ApiConfig.apiKey, // Ganti dengan token asli
      "Accept": "application/pdf",
    };

    print("🔄 Mulai proses download dari URL: $url");

    try {
      // 🔹 1. Minta izin penyimpanan
      if (!(await requestStoragePermission())) {
        print("❌ Izin penyimpanan ditolak.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Izin penyimpanan ditolak")),
        );
        setState(() => _isDownloading = false);
        return;
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      print("📥 HTTP Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        // 🔹 2. Simpan file di folder Download
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final filePath = "${directory.path}/payslip.pdf";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print("✅ File berhasil disimpan di: $filePath");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File disimpan di Download/payslip.pdf")),
        );

        // 🔹 3. Buka file PDF
        await OpenFile.open(filePath);
        print("📖 Berhasil membuka file PDF.");
      } else {
        print("❌ Gagal mengunduh file. Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Gagal mengunduh file (Status: ${response.statusCode})")),
        );
      }
    } catch (e) {
      print("❌ ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  /// Fungsi untuk meminta izin penyimpanan
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("✅ Izin penyimpanan diberikan.");
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download & Open Payslip")),
      body: Center(
        child: IconButton(
          onPressed: _isDownloading ? null : downloadAndOpenPayslip,
          icon: _isDownloading
              ? CircularProgressIndicator(color: Colors.white60)
              : Icon(
                  Icons.download_for_offline_outlined,
                  size: 45,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }
}
