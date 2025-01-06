// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:hcm_3/components/colors.dart';
import 'package:hcm_3/service/api_config.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog_approval.dart';

class ContentApproval extends StatefulWidget {
  const ContentApproval({super.key});

  @override
  State<ContentApproval> createState() => _ContentApprovalState();
}

class _ContentApprovalState extends State<ContentApproval> {
  List<Map<String, dynamic>> activities = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });

    // Call fetchActivities only if userId is available
    if (userId != null) {
      fetchActivities();
    } else {
      print("User ID not found.");
    }
  }

  Future<void> fetchActivities() async {
    if (userId == null) {
      print("Cannot fetch activities: userId is null.");
      return;
    }

    String apiUrl = ApiEndpoints.fetchActivities3(userId);

    final headers = {
      'api-key': ApiConfig.apiKey,
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
              final int id = (activity['id']);
              final String startDate = _formatDate(activity['req_start']);
              final String endDate = _formatDate(activity['req_end']);
              final String createDate = _formatDate1(activity['create_date']);
              final String employeeName =
                  (activity['employee_id']?[0]?['name'] ?? 'Unknown Employee');

              return {
                'description':
                    activity['reason_id'][0]['name'] ?? 'No Description',
                'ovt_rule': activity['rule_id'][0]['name'] ?? 'No rule',
                'employee': employeeName,
                'createDate': createDate,
                'startDate': startDate,
                'endDate': endDate,
                'id': id,
                'state': activity['state'] ?? '-',
              };
            }).toList();
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

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return '-';
    try {
      final DateTime parsedDate = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return '-';
    }
  }

  String _formatDate1(String? dateTimeString) {
    if (dateTimeString == null) return '-';
    try {
      final DateTime parsedDate = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return '-';
    }
  }

  void refreshActivities() {
    fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: activities.map((activity) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => DialogApproval(
                    activity: activity,
                    refreshCallback: refreshActivities,
                  ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 35,
                                  color: AppColors.textdanger,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      activity['description'] ??
                                          'No Description',
                                      style: AppTextStyles.heading2_1,
                                    ),
                                    Text(
                                      activity['employee'] ?? '-',
                                      style: AppTextStyles.heading3_3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Image.asset(
                              activity['state'] == 'approved'
                                  ? 'assets/image_done.png'
                                  : 'assets/resign_check.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
