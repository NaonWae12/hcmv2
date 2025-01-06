// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../components/primary_container.dart';
import '../../components/text_style.dart';
import '../../service/api_config.dart';

class MidleContent extends StatefulWidget {
  const MidleContent({super.key});

  @override
  State<MidleContent> createState() => MidleContentState();
}

class MidleContentState extends State<MidleContent> {
  int? selectedExpenseCategoryId;
  List<Map<String, dynamic>> categories = [];
  int? employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  void selectCategory(int id) {
    setState(() {
      selectedExpenseCategoryId = id;
      print('Selected holiday_status_id: $selectedExpenseCategoryId');
    });
  }

  void resetSelectedExpenseCategory() {
    setState(() {
      selectedExpenseCategoryId = null;
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
    final url = Uri.parse(ApiEndpoints.fetchCategories2());

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
        final List<dynamic>? products = data['data'];

        if (products != null) {
          setState(() {
            categories = products.map((item) {
              final productTmpl = item['product_tmpl_id'][0];
              return {
                'id': item['id'],
                'name': productTmpl['name'],
                'default_code': item['default_code'],
              };
            }).toList();

            if (categories.isNotEmpty) {
              selectedExpenseCategoryId = categories[0]['id'];
              print(
                  'Initial selected expense category id: $selectedExpenseCategoryId');
            }
          });
        } else {
          print('Data produk kosong.');
        }
      } else {
        print('Gagal memuat produk, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
              'Reimburse Type',
              style: AppTextStyles.heading2_1,
            ),
            const SizedBox(height: 8),
            categories.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: selectedExpenseCategoryId == null
                        ? null
                        : categories.firstWhere((category) =>
                            category['id'] ==
                            selectedExpenseCategoryId)['name'],
                    onChanged: (String? newValue) {
                      setState(() {
                        final selectedCategory = categories.firstWhere(
                            (category) => category['name'] == newValue);
                        selectedExpenseCategoryId = selectedCategory['id'];
                        print('Selected ID: $selectedExpenseCategoryId');
                      });
                    },
                    items: categories.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> category) {
                      return DropdownMenuItem<String>(
                        value: category['name'],
                        child: Text(
                          '${category['name']}',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                  )
          ],
        ),
      ),
    );
  }
}
