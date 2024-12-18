import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                icon: const Icon(Icons.arrow_back)),
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
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      obscureText: false,
                      style: AppTextStyles.displayText_2,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PageDetailPayslip()),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
