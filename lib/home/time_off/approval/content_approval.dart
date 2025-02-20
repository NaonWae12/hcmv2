// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../service/api_config.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      userId =
          prefs.getInt('user_id'); // Mengambil user_id dari SharedPreferences
    });

    if (userId != null) {
      fetchActivities();
    } else {
      print("User ID not found.");
    }
  }

  Future<void> fetchActivities() async {
    final apiUrl = ApiEndpoints.fetchActivities(userId.toString());
    final headers = {
      'api-key': ApiConfig.apiKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("Full JSON data received: $jsonData");

        if (jsonData['data'] != null) {
          setState(() {
            activities = (jsonData['data'] as List<dynamic>).map((activity) {
              // Debug print untuk mengecek setiap item
              print("Processing activity: $activity");

              // Pastikan semua elemen valid ditambahkan
              return {
                'description': activity['holiday_status_id'] != null &&
                        activity['holiday_status_id'].isNotEmpty
                    ? activity['holiday_status_id'][0]['name']
                    : 'No Description',
                'employeeName': activity['employee_id'] != null &&
                        activity['employee_id'].isNotEmpty
                    ? activity['employee_id'][0]['name']
                    : 'Unknown',
                'state': activity['state'] ?? 'Unknown',
                'dateFrom': activity['date_from'] ?? 'Unknown',
                'dateTo': activity['date_to'] ?? 'Unknown',
                'duration': activity['duration_display'] ?? 'Unknown',
                'createDate': activity['create_date'] ?? 'Unknown',
                'privateName': activity['private_name'] ?? 'Unknown',
                'id': activity['id'] ?? 'Unknown',
              };
            }).toList();

            // Debug print untuk memastikan semua data telah diambil
            print("All activities: $activities");
          });
        } else {
          print("No 'data' found in response.");
        }
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
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
                    refreshCallback: refreshActivities, // Passing the callback
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
                                SvgPicture.asset('assets/icons/time_off.svg'),
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
                                      "Employee: ${activity['employeeName']}",
                                      style: AppTextStyles.heading3_3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              activity['state'] ?? '-',
                              style: AppTextStyles.heading3_3,
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
