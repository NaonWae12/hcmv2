import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../components/custom_container_time.dart';
import '../../custom_loading.dart';

class ContentActivity extends StatefulWidget {
  const ContentActivity({super.key});

  @override
  State<ContentActivity> createState() => _ContentActivityState();
}

class _ContentActivityState extends State<ContentActivity> {
  String? lastDate;
  int? employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id');
    });
  }

  Future<List<Map<String, dynamic>>?> fetchAttendanceData() async {
    if (employeeId == null) return null;

    final response = await http.get(
      Uri.parse(
          'https://jt-hcm.simise.id/api/hr.attendance/search?domain=[(\'employee_id\',\'=\',$employeeId)]&fields=[\'employee_id\',\'check_in\',\'check_out\',\'worked_hours\']'),
      headers: {
        'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: fetchAttendanceData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoading(imagePath: 'assets/3.png'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No attendance data available.'));
        }
        final currentMonth = DateTime.now().month;
        final currentYear = DateTime.now().year;
        String formatDate(String date) {
          final parsedDate = DateTime.parse(date).toLocal();
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));

          if (parsedDate.year == today.year &&
              parsedDate.month == today.month &&
              parsedDate.day == today.day) {
            return 'Today';
          } else if (parsedDate.year == yesterday.year &&
              parsedDate.month == yesterday.month &&
              parsedDate.day == yesterday.day) {
            return 'Yesterday';
          } else {
            return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
          }
        }

        final List<Map<String, dynamic>> activities = snapshot.data!
            .where((data) {
              final checkInDate = DateTime.parse(data['check_in']).toLocal();
              return checkInDate.month == currentMonth &&
                  checkInDate.year == currentYear;
            })
            .map((data) => {
                  'date': formatDate(data['check_in']),
                  'startTime': _formatTime(data['check_in']),
                  'endTime': _formatTime(
                      data['check_out']), // Nilai dapat berupa 'N/A' jika false
                  'icon': 'assets/icons/attendance_check.svg',
                  'description': 'Attendance Check',
                  'name': data['employee_id'][0]['name'] ?? 'N/A',
                  'formattedCheckIn': _formatTime(data['check_in']),
                  'formattedCheckout': _formatTime(data['check_out']),
                  'workedHours':
                      (data['worked_hours'] as num?)?.toStringAsFixed(1) ??
                          '0.0',
                })
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activities.map((activity) {
                bool showDate = activity['date'] != lastDate;
                if (showDate) {
                  lastDate = activity['date'];
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDate) ...[
                        Text(
                          activity['date'],
                          style: AppTextStyles.heading3_3,
                        ),
                        const SizedBox(height: 8),
                      ],
                      PrimaryContainer(
                        height:
                            80, // Increased height to accommodate worked hours
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(activity['icon']),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          activity['name'],
                                          style: AppTextStyles.heading2_1,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              activity['formattedCheckIn'],
                                              style: AppTextStyles.heading3_7,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                '→',
                                                style: AppTextStyles.heading3_3,
                                              ),
                                            ),
                                            Text(
                                              activity['formattedCheckout'],
                                              style: AppTextStyles.heading3_8,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    CustomContainerTime(
                                      width: 75,
                                      height: 30,
                                      color: Colors.green[100],
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${activity['workedHours']} hours',
                                          style: AppTextStyles.smalBoldlLabel,
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
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(dynamic dateTime) {
    if (dateTime == null || dateTime == false) return 'N/A';

    try {
      // Parse waktu UTC
      DateTime utcTime = DateTime.parse(dateTime);
      // Dapatkan offset zona waktu lokal
      Duration localOffset = DateTime.now().timeZoneOffset;
      // Tambahkan offset ke waktu UTC
      DateTime localTime = utcTime.add(localOffset);
      // print('Original UTC Time: $utcTime');
      // print('Converted Local Time: $localTime');
      // print('Local Time Offset: ${localTime.timeZoneOffset}');
      // Format waktu
      return DateFormat('HH:mm a').format(localTime);
    } catch (e) {
      // print('Error converting time: $e');
      return 'N/A';
    }
  }
}
