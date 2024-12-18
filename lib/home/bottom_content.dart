// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../attendance/history_attendance/page_activity.dart';
import '../components/custom_container_time.dart';
import '../custom_loading.dart';

class BottomContent extends StatefulWidget {
  const BottomContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  BottomContentState createState() => BottomContentState();
}

class BottomContentState extends State<BottomContent> {
  int? employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> refreshData() async {
    // Logika refresh data di BottomContent
    setState(() {
      // Update state
    });
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id');
    });
  }

  Future<List<Map<String, dynamic>>?> fetchAttendanceData() async {
    final response = await http.get(
      Uri.parse(
          'https://jt-hcm.simise.id/api/hr.attendance/search?domain=[(\'employee_id\',\'=\',$employeeId)]&fields=[\'employee_id\',\'check_in\',\'check_out\',\'worked_hours\']'),
      headers: {
        'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Decoded Data: $data');

      if (data['data'] != null && data['data'].isNotEmpty) {
        print('Attendance Data Found');
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('No attendance data available');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
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
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PrimaryContainer(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Attendance Tracking',
                            style: AppTextStyles.heading1_1,
                          ),
                        ],
                      ),
                    ]))),
          ));
        }

        final List<Map<String, dynamic>> attendanceData = snapshot.data!
          ..sort((a, b) {
            final dateA = DateTime.parse(a['check_in']);
            final dateB = DateTime.parse(b['check_in']);
            return dateB.compareTo(dateA); // Sort descending by check_in date
          });

        final List<Map<String, dynamic>> latestThreeData =
            attendanceData.take(3).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: PrimaryContainer(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Tracking',
                        style: AppTextStyles.heading1_1,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PageActivity()),
                          );
                        },
                        child: Text(
                          'View all',
                          style: AppTextStyles.heading3,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestThreeData.length,
                    itemBuilder: (context, index) {
                      final employee = latestThreeData[index]['employee_id'];
                      final name = employee != null && employee.isNotEmpty
                          ? employee[0]['name']
                          : 'N/A';
                      final workedHours =
                          (latestThreeData[index]['worked_hours'] as num?)
                                  ?.round()
                                  .toString() ??
                              '0';
                      final checkIn =
                          latestThreeData[index]['check_in'] ?? 'N/A';
                      final checkOut = latestThreeData[index]['check_out'];
                      // Tambahkan fungsi konversi waktu UTC ke zona waktu lokal yang lebih spesifik
                      DateTime convertUtcToLocalTime(String utcTimeString) {
                        if (utcTimeString == 'N/A') return DateTime.now();

                        // Parse waktu UTC
                        DateTime utcTime = DateTime.parse(utcTimeString);

                        // Secara eksplisit konversi ke zona waktu lokal
                        return utcTime.add(DateTime.now().timeZoneOffset);
                      }

// Dalam method build, gunakan fungsi konversi yang baru ini:
                      final formattedCheckIn = checkIn != 'N/A'
                          ? TimeOfDay.fromDateTime(
                                  convertUtcToLocalTime(checkIn))
                              .format(context)
                          : 'N/A';
                      final formattedCheckOut =
                          (checkOut is String && checkOut.isNotEmpty)
                              ? TimeOfDay.fromDateTime(
                                      convertUtcToLocalTime(checkOut))
                                  .format(context)
                              : 'N/A';
                      final formattedCheckInDate = checkIn != 'N/A'
                          ? DateFormat('yyyy-MM-dd')
                              .format(convertUtcToLocalTime(checkIn))
                          : 'N/A';

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/attendance_check.svg'),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: AppTextStyles.heading2_1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(formattedCheckIn,
                                              style: AppTextStyles.heading3_7),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('|',
                                                style:
                                                    AppTextStyles.heading3_2),
                                          ),
                                          Text(
                                            formattedCheckOut,
                                            style: AppTextStyles.heading3_8,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        formattedCheckInDate,
                                        style: AppTextStyles.smalBoldlLabel_3,
                                      )
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
                                    '$workedHours hours',
                                    style: AppTextStyles.smalBoldlLabel,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey[101],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
