import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../components/custom_container_time.dart';
import '../../components/primary_button.dart';
import '../../components/primary_container.dart';
import '../../components/text_style.dart';
import 'history_reimburse/page_history_reimburse_list.dart';
import 'reimburse_dialog.dart';
import 'report/page_create_report.dart';

class ReimburseList extends StatefulWidget {
  const ReimburseList({super.key});

  @override
  State<ReimburseList> createState() => ReimburseListState();
}

class ReimburseListState extends State<ReimburseList> {
  late Future<List<dynamic>> _expenseData;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _expenseData = fetchExpenseData();
  }

  Future<int> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employee_id') ??
        0; // Default ke 0 jika tidak ditemukan
  }

  Future<List<dynamic>> fetchExpenseData() async {
    final employeeId = await getEmployeeId();
    final url =
        "https://jt-hcm.simise.id/api/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date','state']";

    final headers = {
      'Content-Type': 'application/json',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        // Pastikan data tidak null atau kosong
        if (jsonResponse['data'] == null ||
            (jsonResponse['data'] as List).isEmpty) {
          return []; // Kembalikan list kosong jika tidak ada data
        }

        // Lakukan filter data dengan state = 'draft'
        final filteredData = (jsonResponse['data'] as List)
            .where((item) => item['state'] == 'draft')
            .toList();

        return filteredData;
      } else {
        // Jika success == false, return list kosong, jangan lempar Exception
        return [];
      }
    } else {
      // Handle error response status (misal 404 atau 500)
      return [];
    }
  }

  String formatRupiah(double amount) {
    return 'Rp. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  void refreshData() {
    setState(() {
      _expenseData = fetchExpenseData(); // Panggil ulang fetchExpenseData
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _expenseData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Jika data tidak ada, seluruh halaman tidak ditampilkan
          return const SizedBox.shrink();
        } else {
          // Hanya mengambil 3 item pertama dari data
          final data = snapshot.data!.take(3).toList();
          return PrimaryContainer(
            borderRadius: BorderRadius.circular(0),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reimburse List',
                        style: AppTextStyles.heading2_1,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded; // Mengubah status item
                          });
                        },
                        icon: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ],
                  ),
                  if (_isExpanded)
                    Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/payroll.svg'),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
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
                                              item['total_amount_currency'] ??
                                                  0),
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
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PageHistoryReimburseList()),
                        );
                      },
                      child: Text(
                        'Show All',
                        style: AppTextStyles.smalBoldlLabel_3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PrimaryButton(
                      backgroundColor: AppColors.textdanger,
                      buttonHeight: 50,
                      buttonWidth: MediaQuery.of(context).size.width,
                      buttonText: 'Create Report',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageCreateReport()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
