// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../components/primary_container.dart';
import '../../components/text_style.dart';
import 'midle_content1.dart';

class TopContent extends StatefulWidget {
  final GlobalKey<MidleContent1State> midleContentKey;
  final Function(bool) onSupportDocumentChanged;

  const TopContent(
      {super.key,
      required this.midleContentKey,
      required this.onSupportDocumentChanged});

  @override
  State<TopContent> createState() => TopContentState();
}

class TopContentState extends State<TopContent> {
  int? selectedHolidayStatusId;
  List<Map<String, dynamic>> categories = [];
  int? employeeId;
  bool? supportDocument;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  void selectCategory(int id) {
    setState(() {
      selectedHolidayStatusId = id;
      print('Selected holiday_status_id: $selectedHolidayStatusId');
    });
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id');
      print('Loaded employee_id: $employeeId');
    });
    if (employeeId != null) {
      fetchCategories();
    } else {
      print('Employee ID tidak ditemukan di SharedPreferences');
    }
  }

  Future<void> fetchCategories() async {
    if (employeeId == null) {
      print('Employee ID is null');
      return;
    }

    final url = Uri.parse(ApiEndpoints.fetchCategories(employeeId.toString()));

    try {
      final response = await http.get(
        url,
        headers: {
          'api-key': ApiConfig.apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? categoriesData = data['holiday_status'];

        if (categoriesData != null) {
          setState(() {
            categories = categoriesData.map((item) {
              return {
                'id': (item['id'] as num?)?.toInt(),
                'name': item['name'] ?? 'Unknown',
                'total_allocated': (item['total_allocated'] as num?)
                    ?.toInt(), // Tetap null jika tidak ada
                'total_used': (item['total_used'] as num?)
                    ?.toInt(), // Tetap null jika tidak ada
                'support_document': item['support_document'] ?? true,
              };
            }).toList();

            if (categories.isNotEmpty) {
              selectedHolidayStatusId = categories[0]['id'];
              supportDocument = categories[0]['support_document'] ?? true;

              final totalAllocated = categories[0]['total_allocated'];
              final totalUsed = categories[0]['total_used'];

              print('Total Allocated: $totalAllocated, Total Used: $totalUsed');

              // Cek apakah totalAllocated & totalUsed valid sebelum update MidleContent1
              if (totalAllocated != null && totalUsed != null) {
                widget.midleContentKey.currentState
                    ?.updateAllocatedUsed(totalAllocated, totalUsed);
              } else {
                widget.midleContentKey.currentState
                    ?.updateAllocatedUsed(null, null);
              }

              widget.onSupportDocumentChanged(supportDocument ?? true);
            } else {
              print('Categories list is empty');
            }
          });
        } else {
          print('holiday_status is null or not a list');
        }
      } else {
        print('Failed to load categories. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while fetching categories: $e');
    }
  }

  void reset() {
    setState(() {
      selectedHolidayStatusId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Off Type',
              style: AppTextStyles.heading2_1,
            ),
            const SizedBox(height: 8),
            categories.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: selectedHolidayStatusId == null
                        ? null
                        : categories.firstWhere((category) =>
                            category['id'] == selectedHolidayStatusId)['name'],
                    onChanged: (String? newValue) {
                      setState(() {
                        final selectedCategory = categories.firstWhere(
                            (category) => category['name'] == newValue);
                        selectedHolidayStatusId = selectedCategory['id'];
                        print(
                            'Selected holiday_status_id: $selectedHolidayStatusId');

                        final supportDocument =
                            selectedCategory['support_document'];
                        print(
                            'Support Document status for selected category: $supportDocument');

                        // Mendapatkan total_allocated dan total_used
                        final totalAllocated =
                            selectedCategory['total_allocated'];
                        final totalUsed = selectedCategory['total_used'];
                        print(
                            'Total Allocated: $totalAllocated, Total Used: $totalUsed');

                        // Memperbarui data totalAllocated dan totalUsed di MidleContent1
                        widget.midleContentKey.currentState
                            ?.updateAllocatedUsed(totalAllocated, totalUsed);
                        widget
                            .onSupportDocumentChanged(supportDocument ?? true);
                      });
                    },
                    items: categories.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> category) {
                      return DropdownMenuItem<String>(
                        value: category['name'],
                        child: Text(
                          category['name'],
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                  ),
          ],
        ),
      ),
    );
  }
}
