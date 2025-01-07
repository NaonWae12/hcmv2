// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../service/api_config.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import '../attendance/history_attendance/page_activity.dart';
import '../components/custom_container_time.dart';
import '../custom_loading.dart';

class BottomContent extends StatefulWidget {
  const BottomContent({super.key});

  @override
  BottomContentState createState() => BottomContentState();
}

class BottomContentState extends State<BottomContent> {
  int? employeeId;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    _checkConnectivity();
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  void refreshContent() {
    setState(() {
      // Refresh UI dan ulangi pengecekan konektivitas
      _checkConnectivity();
    });
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id');
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isOffline = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isOffline = true;
      });
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAttendanceData() async {
    if (isOffline || employeeId == null) return null;

    final url = ApiEndpoints.fetchAttendance(employeeId.toString());
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'api-key': ApiConfig.apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] != null
            ? List<Map<String, dynamic>>.from(data['data'])
            : null;
      }
    } on SocketException {
      setState(() => isOffline = true); // Menandai bahwa koneksi bermasalah
    } catch (e) {
      print('Fetch error: $e');
    }
    return null;
  }

  Widget buildOfflineMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: PrimaryContainer(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.red, size: 32),
                    const SizedBox(width: 8),
                    Text(
                      'Anda saat ini sedang offline',
                      style: AppTextStyles.heading1_1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAttendanceList(List<Map<String, dynamic>> attendanceData) {
    final sortedData = attendanceData
      ..sort((a, b) {
        final dateA = DateTime.parse(a['check_in']);
        final dateB = DateTime.parse(b['check_in']);
        return dateB.compareTo(dateA);
      });
    final latestThreeData = sortedData.take(3).toList();

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
                          builder: (context) => const PageActivity(),
                        ),
                      );
                    },
                    child: Text(
                      'View all',
                      style: AppTextStyles.heading3,
                    ),
                  ),
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
                  final checkIn = latestThreeData[index]['check_in'] ?? 'N/A';
                  final checkOut = latestThreeData[index]['check_out'];

                  DateTime convertUtcToLocalTime(String utcTimeString) {
                    if (utcTimeString == 'N/A') return DateTime.now();
                    DateTime utcTime = DateTime.parse(utcTimeString);
                    return utcTime.add(DateTime.now().timeZoneOffset);
                  }

                  final formattedCheckIn = checkIn != 'N/A'
                      ? TimeOfDay.fromDateTime(convertUtcToLocalTime(checkIn))
                          .format(context)
                      : 'N/A';
                  final formattedCheckOut = (checkOut is String &&
                          checkOut.isNotEmpty)
                      ? TimeOfDay.fromDateTime(convertUtcToLocalTime(checkOut))
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTextStyles.heading2_1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formattedCheckIn,
                                        style: AppTextStyles.heading3_7,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '|',
                                          style: AppTextStyles.heading3_2,
                                        ),
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
  }

  Widget buildAttendanceListEmpty() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: PrimaryContainer(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Tracking',
                        style: AppTextStyles.heading1_1,
                      ),
                    ],
                  )
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return buildOfflineMessage();
    }

    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: fetchAttendanceData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomLoading(imagePath: 'assets/3.png'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildAttendanceListEmpty();
        }

        return buildAttendanceList(snapshot.data!);
      },
    );
  }
}
