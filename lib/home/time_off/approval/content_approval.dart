// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    String apiUrl =
        "https://jt-hcm.simise.id/api/hr.leave/search?domain=[('state','in',['confirm','validate1']),('|'), ('employee_id.user_id', '!=', 2),('|'),('%26'),('state','=','confirm'),('holiday_status_id.leave_validation_type','=','hr'),('state','=','validate1')]&fields=['holiday_status_id','employee_id','state']";

    final headers = {
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
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
                  builder: (context) => DialogApproval(activity: activity),
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
