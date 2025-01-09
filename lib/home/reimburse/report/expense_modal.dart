// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:hcm_3/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '/components/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/custom_container_time.dart';
import '../reimburse_dialog.dart';

class ExpenseModal extends StatefulWidget {
  final Function(List<dynamic>) onSelectedItems; // Callback untuk mengirim data

  const ExpenseModal({super.key, required this.onSelectedItems});

  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  late Future<List<dynamic>> _expenseData;
  final List<dynamic> _selectedItems = [];

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
    final url = ApiEndpoints.fetchExpenseData6(employeeId);

    final headers = {
      'Content-Type': 'application/json',
      'api-key': ApiConfig.apiKey,
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['data'];
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Expense',
            style: AppTextStyles.heading2_1,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<dynamic>>(
              future: _expenseData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                                    Checkbox(
                                      value: _selectedItems.contains(item),
                                      onChanged: (bool? isSelected) {
                                        setState(() {
                                          if (isSelected == true) {
                                            _selectedItems.add(item);
                                            print('Item added: ${item['id']}');
                                          } else {
                                            _selectedItems.remove(item);
                                            print(
                                                'Item removed: ${item['id']}');
                                          }
                                        });
                                      },
                                    ),
                                    SvgPicture.asset(
                                        'assets/icons/payroll.svg'),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? 'No description',
                                          style: AppTextStyles.heading2_1,
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
                                    child: Text(
                                      formatRupiah(
                                          item['total_amount_currency'] ?? 0),
                                      style: AppTextStyles.smalBoldlLabel,
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
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup modal
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  print('Final selected items: $_selectedItems');
                  widget.onSelectedItems(_selectedItems);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
