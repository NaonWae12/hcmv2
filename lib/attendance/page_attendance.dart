// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import '/navbar.dart';
import 'package:http/http.dart' as http;
import '/components/colors.dart';
import '/components/text_style.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'custom_dialog.dart';

class PageAttendance extends StatefulWidget {
  const PageAttendance({super.key});

  @override
  State<PageAttendance> createState() => _PageAttendanceState();
}

class _PageAttendanceState extends State<PageAttendance> {
  late int employeeId;
  String? currentCheckInTime;
  String? currentCheckOutTime;
  bool hasCheckedIn = false;
  bool showCheckOutButton = false;
  String todayDate = _getTodayDate();

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    _checkAndCleanOldData();
    _loadAttendanceStatus();
  }

  static String _getTodayDate() {
    DateTime.now().toUtc();
    return "\${now.year}-\${now.month.toString().padLeft(2, '0')}-\${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id') ?? 0;
    });
  }

  Future<void> _checkAndCleanOldData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('attendance_date');

    if (storedDate != todayDate) {
      // Hapus data lama jika hari sudah berganti
      await prefs.remove('check_in_time');
      await prefs.remove('check_out_time');
      await prefs.remove('attendance_date');
    }
  }

  Future<void> _loadAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkInTime = prefs.getString('check_in_time');
    final checkOutTime = prefs.getString('check_out_time');

    setState(() {
      // Konversi waktu UTC ke waktu lokal sebelum ditampilkan
      currentCheckInTime = checkInTime != null
          ? _formatLocalTime(DateTime.parse(checkInTime))
          : null;
      currentCheckOutTime = checkOutTime != null
          ? _formatLocalTime(DateTime.parse(checkOutTime))
          : null;
      hasCheckedIn = checkInTime != null;
      showCheckOutButton = checkOutTime == null && checkInTime != null;
    });
  }

  String _formatLocalTime(DateTime utcTime) {
    DateTime localTime = utcTime.toLocal(); // Konversi ke waktu lokal
    return DateFormat('hh:mm a').format(localTime);
  }

  Future<void> _checkIn() async {
    final nowUtc = DateTime.now().toUtc();
    final formattedCheckInTime = nowUtc.toIso8601String();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_in_time', formattedCheckInTime);
    await prefs.setString('attendance_date', todayDate);

    setState(() {
      currentCheckInTime = _formatLocalTime(nowUtc);
      hasCheckedIn = true;
      showCheckOutButton = true;
    });

    await showCheckInDialog(context,
        "Anda telah berhasil check-in! Selamat bekerja dan semoga hari ini penuh produktivitas!");
  }

  Future<void> _checkOut() async {
    final nowUtc = DateTime.now().toUtc();
    final formattedCheckOutTime = nowUtc.toIso8601String();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkInTime = prefs.getString('check_in_time');

    final url = Uri.parse('https://jt-hcm.simise.id/api/hr.attendance/create');
    final headers = {
      "Content-Type": "application/json",
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };
    final body = jsonEncode({
      "employee_id": employeeId,
      "check_in": checkInTime,
      "check_out": formattedCheckOutTime,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        await prefs.setString('check_out_time', formattedCheckOutTime);
        setState(() {
          currentCheckOutTime = _formatLocalTime(nowUtc);
          showCheckOutButton = false;
        });
        await showCheckOutDialog(context,
            "Anda telah berhasil check-out! Selamat beristirahat. Terima kasih atas kerja keras Anda hari ini!");
      } else {
        await showDialog1(context, "Gagal mengirim absensi");
      }
    } catch (e) {
      await showDialog1(context, "Terjadi kesalahan pada jaringan");
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good morning, team!";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon, team!";
    } else if (hour >= 17 && hour < 20) {
      return "Good evening, team!";
    } else {
      return "Good night, team!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.fill)),
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Navbar()),
                          );
                        },
                        icon: const Icon(Icons.arrow_back)),
                    Text(
                      'Attendance Check',
                      style: AppTextStyles.heading1_1,
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/face_id.png',
                        height: 100,
                        width: 100,
                      ),
                      if (hasCheckedIn) ...[
                        const SizedBox(height: 15),
                        Text('Check-In Time: $currentCheckInTime'),
                        if (currentCheckOutTime != null)
                          Text('Check-Out Time: $currentCheckOutTime'),
                        const SizedBox(height: 15),
                      ] else
                        Text(
                          "Haven't clocked in yet",
                          style: AppTextStyles.heading2,
                        ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Text(
                          "${_getGreeting()}, team! Don't forget to fill in your daily attendance.",
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      if (!hasCheckedIn)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideAction(
                            onSubmit: () async => await _checkIn(),
                            innerColor: AppColors.textColor1,
                            outerColor: AppColors.primaryColor,
                            text: 'Swipe right to clock in',
                            textStyle: AppTextStyles.heading2_3,
                          ),
                        ),
                      if (hasCheckedIn && showCheckOutButton)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideAction(
                            onSubmit: () async => await _checkOut(),
                            innerColor: AppColors.textdanger,
                            outerColor: AppColors.primaryColor,
                            text: 'Swipe right to clock out',
                            textStyle: AppTextStyles.heading2_3,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
