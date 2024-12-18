import 'package:flutter/material.dart';
import '/components/colors.dart';
import '/components/custom_choice_container.dart';
import '/components/secondary_container.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopContent extends StatefulWidget {
  const TopContent({super.key});

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  String? checkInTime;
  String? checkOutTime;

  @override
  void initState() {
    super.initState();
    _loadCheckInTime(); // Panggil fungsi untuk memuat data check-in
    _loadChecOutTime();
  }

  // Fungsi untuk memuat data check-in dari SharedPreferences
  Future<void> _loadCheckInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkInTime = prefs.getString('check_in_time'); // Ambil data check-in
    });
  }

  Future<void> _loadChecOutTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkOutTime = prefs.getString('check_out_time');
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(24),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Today’s Overview", style: AppTextStyles.heading2),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(formattedDate, style: AppTextStyles.heading1_1),
            ),
            const SizedBox(height: 14),
            SecondaryContainer(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Clock In', style: AppTextStyles.heading3),
                          Text(
                            checkInTime != null
                                ? _formatTime(
                                    checkInTime!) // Format waktu jika ada
                                : '-- : --', // Default jika tidak ada data check-in
                            style: AppTextStyles.displayText_2,
                          ),
                          if (checkInTime == null)
                            CustomChoiceContainer(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 35,
                              color: AppColors.textdanger,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Not yet',
                                  style: AppTextStyles.smalBoldlLabel_2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Clock Out', style: AppTextStyles.heading3),
                          Text(
                            checkOutTime != null
                                ? _formatTime(
                                    checkOutTime!) // Format waktu jika ada
                                : '-- : --', // Default jika tidak ada data check-in
                            style: AppTextStyles.displayText_2,
                          ),
                          if (checkOutTime == null)
                            CustomChoiceContainer(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 35,
                              color: AppColors.textdanger,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Not yet',
                                  style: AppTextStyles.smalBoldlLabel_2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  // Fungsi untuk memformat waktu check-in menjadi 'hh:mm AM/PM'
  String _formatTime(String utcTime) {
    try {
      DateTime time =
          DateTime.parse(utcTime).toLocal(); // Konversi UTC ke lokal
      return DateFormat('hh:mm a').format(time); // Format waktu
    } catch (e) {
      return '-- : --'; // Jika format salah
    }
  }
}
