// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/home/overtime/page_overtime.dart';
import '../components/text_style.dart';
import 'payslip/page_payslip_pin.dart';
import 'reimburse/page_reimburse.dart';
import 'time_off/page_time_off.dart';
import 'dart:io';

class MidleContent extends StatelessWidget {
  const MidleContent({super.key});

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Koneksi tersedia
      }
    } on SocketException catch (_) {
      return false; // Tidak ada koneksi
    }
    return false;
  }

  void showOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oups!'),
          content: const Text(
              'Pastikan internet Anda stabil untuk mengakses fitur ini.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Reimburse',
      'Payslip',
      'Time Off',
      'Overtime',
    ];
    final List<String> imagePaths = [
      'assets/Payroll.png',
      'assets/Payslip.png',
      'assets/Time Off.png',
      'assets/Overtime.png',
    ];
    final List<Widget> pages = [
      const PageReimburse(),
      const PagePayslipPin(),
      const PageTimeOff(),
      const PageOvertime(),
    ];
    const int itemCount = 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Wrap(
            spacing: 25,
            runSpacing: 10,
            children: List.generate(itemCount, (index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final isConnected = await checkInternetConnection();
                      if (isConnected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pages[index]),
                        );
                      } else {
                        showOfflineDialog(context);
                      }
                    },
                    child: PrimaryContainer(
                      height: 56,
                      width: 56,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          imagePaths[index],
                          scale: 1.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    titles[index],
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3_1,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
