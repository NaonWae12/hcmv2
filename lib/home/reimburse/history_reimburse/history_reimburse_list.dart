import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/custom_container_time.dart';
import '../../../components/text_style.dart';
import '../../../custom_loading.dart';
import '../../../service/api_config.dart';
import '../reimburse_dialog.dart';

class HistoryReimburseList extends StatefulWidget {
  const HistoryReimburseList({super.key});

  @override
  State<HistoryReimburseList> createState() => _HistoryReimburseListState();
}

class _HistoryReimburseListState extends State<HistoryReimburseList> {
  late Future<List<dynamic>> _expenseData;

  @override
  void initState() {
    super.initState();
    _expenseData = fetchExpenseData();
  }

  Future<int> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employee_id') ?? 0;
  }

  Future<List<dynamic>> fetchExpenseData() async {
    final employeeId = await getEmployeeId();
    final url = ApiEndpoints.fetchExpenseData2(employeeId.toString());

    final headers = {
      'Content-Type': 'application/json',
      'api-key': ApiConfig.apiKey,
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        // Filter hanya data dengan state = "draft"
        final filteredData = (jsonResponse['data'] as List)
            .where((item) => item['state'] == 'draft') // Cek state
            .toList();

        return filteredData;
      } else {
        throw Exception('Failed to fetch data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load API: ${response.statusCode}');
    }
  }

  String formatRupiah(double amount) {
    return 'Rp. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<dynamic>>(
        future: _expenseData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CustomLoading(imagePath: 'assets/3.png'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return Column(
              children: data.map((item) {
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
                          amount:
                              formatRupiah(item['total_amount_currency'] ?? 0),
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
            );
          }
        },
      ),
    );
  }
}
