// ignore_for_file: avoid_print, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../components/custom_container_time.dart';
import '../../../components/text_style.dart';
import '../../../service/api_config.dart';
import '../reimburse_dialog.dart';
import '../report/submit_report/page_submit_report.dart';

class DetailModal extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailModal({
    super.key,
    required this.data,
  });

  @override
  State<DetailModal> createState() => _DetailModalState();
}

class _DetailModalState extends State<DetailModal> {
  List<dynamic> expenseData = [];

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
  }

  Future<int> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employee_id') ?? 0;
  }

  Future<void> fetchExpenseData() async {
    try {
      final employeeId = await getEmployeeId();
      final url = ApiEndpoints.fetchExpenseData3(employeeId.toString());

      final headers = {
        'Content-Type': 'application/json',
        'api-key': ApiConfig.apiKey,
      };

      print('Fetching data from URL: $url'); // Debug URL
      final response = await http.get(Uri.parse(url), headers: headers);

      print('Response Status: ${response.statusCode}'); // Debug status code
      print('Response Body: ${response.body}'); // Debug full response

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            expenseData = jsonResponse['data']; // Simpan data ke expenseData
          });
          print('Fetched Expense Data: $expenseData'); // Debug expenseData
        } else {
          print('Error: ${jsonResponse['message']}');
          throw Exception('Failed to fetch data: ${jsonResponse['message']}');
        }
      } else {
        print('Error loading API: ${response.statusCode}');
        throw Exception('Failed to load API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchExpenseData: $e'); // Debug exception
    }
  }

  String formatRupiah(double amount) {
    return 'Rp. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  @override
  @override
  Widget build(BuildContext context) {
    print('Widget Data: ${widget.data}'); // Debug widget data
    print(
        'Expense Line IDs: ${widget.data['expense_line_ids']}'); // Debug line IDs
    print('Current Expense Data: $expenseData'); // Debug fetched expense data

    // Ambil expense_line_ids dari data halaman sebelumnya
    final List<dynamic> expenseLineIds = widget.data['expense_line_ids'] ?? [];
    final List<int> lineIds =
        expenseLineIds.map((item) => item['id'] as int).toList();

    // Filter data dari API berdasarkan ID yang sama dengan data halaman sebelumnya
    final filteredExpenseData =
        expenseData.where((item) => lineIds.contains(item['id'])).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Detail', style: AppTextStyles.heading1),
                if (widget.data['state'] == 'draft')
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageSubmitReport(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.approval),
                  ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text('Name: ${widget.data['name']}',
                style: AppTextStyles.heading2_1),
            Text('Status: ${widget.data['state']}',
                style: AppTextStyles.heading3_3),
            Text('Created Date: ${widget.data['create_date']}',
                style: AppTextStyles.heading3_3),
            const SizedBox(height: 12.0),
            Text('Additional Expenses:', style: AppTextStyles.heading2_1),
            const SizedBox(height: 8.0),
            if (filteredExpenseData.isNotEmpty)
              Column(
                children: filteredExpenseData.map((item) {
                  return GestureDetector(
                    onTap: () {
                      final product = item['product_id'];
                      final productName = (product != null &&
                              product is List &&
                              product.isNotEmpty)
                          ? product[0]['name'] ?? 'No product name'
                          : 'No product name';

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReimburseDialog(
                            name: item['name'] ?? 'No description',
                            date: item['date'] ?? 'No date',
                            amount: formatRupiah(
                                item['total_amount_currency'] ?? 0),
                            productName: productName,
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/payroll.svg'),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.80,
                                      child: Text(
                                        item['name'] ?? 'No description',
                                        style: AppTextStyles.heading2_1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      item['date'] ?? 'No date',
                                      style: AppTextStyles.heading3,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    formatRupiah(
                                        item['total_amount_currency'] ?? 0),
                                    style: AppTextStyles.smalBoldlLabel,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                }).toList(),
              )
            else
              Text('No additional expenses found.',
                  style: AppTextStyles.heading3_3),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
