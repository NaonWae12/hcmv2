// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity_detail_dialog.dart';

class ContentHistory extends StatefulWidget {
  const ContentHistory({super.key});

  @override
  State<ContentHistory> createState() => _ContentHistoryState();
}

class _ContentHistoryState extends State<ContentHistory> {
  List<Map<String, dynamic>> activities = [];
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

    if (employeeId != null) {
      fetchActivities();
    } else {
      print("Employee ID not found.");
    }
  }

  Future<void> fetchActivities() async {
    if (employeeId == null) {
      print("Cannot fetch activities: employeeId is null.");
      return;
    }

    String apiUrl =
        "https://jt-hcm.simise.id/api/hr.leave/search?domain=[('employee_id','=',$employeeId)]&fields=['employee_id','holiday_status_id','name','date_from','date_to','duration_display','state','create_date','private_name','attachment_ids']";

    final headers = {
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("Full JSON data received: $jsonData");

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          setState(() {
            activities = (jsonData['data'] as List<dynamic>).map((activity) {
              // Cek validitas holiday_status_id
              final holidayStatus = (activity['holiday_status_id'] is List &&
                      activity['holiday_status_id'].isNotEmpty)
                  ? activity['holiday_status_id'][0]['name']
                  : 'No Description';

              // Cek validitas date_from dan date_to
              final dateFrom = (activity['date_from'] != null &&
                      activity['date_from'] != false)
                  ? _formatDate(activity['date_from'])
                  : '-';
              final dateTo =
                  (activity['date_to'] != null && activity['date_to'] != false)
                      ? _formatDate(activity['date_to'])
                      : '-';

              // Cek validitas private_name
              final privateName = activity['private_name'] ?? '-';

              // Cek validitas duration_display
              final durationDisplay = activity['duration_display'] ?? '-';

              // Cek validitas state
              final state = activity['state'] ?? 'draft';

              // Cek validitas create_date
              final createDate = activity['create_date'] ?? '-';

              // Cek validitas attachment_ids
              final attachmentIds = (activity['attachment_ids'] is List &&
                      activity['attachment_ids'].isNotEmpty)
                  ? (activity['attachment_ids'] as List<dynamic>)
                      .map((attachment) => attachment['id'])
                      .toList()
                  : [];

              return {
                'description': holidayStatus,
                'startDate': dateFrom,
                'endDate': dateTo,
                'private_name': privateName,
                'duration_display': durationDisplay,
                'state': state,
                'create_date': createDate,
                'attachment_ids': attachmentIds,
              };
            }).toList();

            // Debugging: Cek hasil data setelah parsing
            print("Parsed activities: $activities");

            // Sortir berdasarkan create_date jika valid
            activities.sort((a, b) {
              try {
                DateTime dateA = DateTime.parse(a['create_date']);
                DateTime dateB = DateTime.parse(b['create_date']);
                return dateB.compareTo(dateA);
              } catch (e) {
                print("Error sorting by create_date: $e");
                return 0; // Abaikan jika gagal parsing tanggal
              }
            });
          });
        } else {
          print("No 'data' found in response or 'data' is null.");
        }
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String _formatDate(String dateTimeString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return '-';
    }
  }

  String formatDisplayDate(String date) {
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
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? lastDisplayedDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: activities.map((activity) {
            String formattedDate = formatDisplayDate(activity['create_date']);
            bool showDate = formattedDate != lastDisplayedDate;

            if (showDate) {
              lastDisplayedDate = formattedDate;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      formattedDate,
                      style: AppTextStyles.heading3_1,
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ActivityDetailDialog(activity: activity),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryContainer(
                          height: 68,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/time_off.svg'),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          activity['description'] ??
                                              'No Description',
                                          style: AppTextStyles.heading2_1,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              activity['startDate'] ?? '-',
                                              style: AppTextStyles.heading3_3,
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
                                              activity['endDate'] ?? '-',
                                              style: AppTextStyles.heading3_3,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  activity['state'] == 'done'
                                      ? 'assets/icons/done.svg'
                                      : 'assets/icons/doc_rev.svg',
                                  width: 48.0,
                                  height: 48.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
