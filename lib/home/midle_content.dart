import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/home/overtime/page_overtime.dart';

import '../components/text_style.dart';
// import 'calendar/page_calendar.dart';
import 'payslip/page_payslip_pin.dart';
// import 'resign/page_resign_form.dart';
import 'reimburse/page_reimburse.dart';
import 'time_off/page_time_off.dart';

class MidleContent extends StatelessWidget {
  const MidleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Reimburse',
      'Payslip',
      // 'Counseling',
      'Time Off',
      // 'Calendar',
      'Overtime',
      // 'Resign',
      // 'Other',
    ];
    final List<String> imagePaths = [
      'assets/Payroll.png',
      'assets/Payslip.png',
      // 'assets/Counseling.png',
      'assets/Time Off.png',
      'assets/Overtime.png',
      // 'assets/Calendar.png',
      // 'assets/Resign.png',
      // 'assets/Other.png',
    ];
    final List<Widget> pages = [
      const PageReimburse(),
      const PagePayslipPin(),
      // const SettingsPage3(),
      const PageTimeOff(),
      // const PageCalendar(),
      const PageOvertime(),
      // const PageResignForm(),
      // const SettingsPage8(),
    ];
    const int itemCount = 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Wrap(
            spacing: 25, // Jarak horizontal antara item
            runSpacing: 10, // Jarak vertikal antara baris
            children: List.generate(itemCount, (index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      );
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
