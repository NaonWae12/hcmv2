import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../custom_loading.dart';
import '/components/text_style.dart';
import '/components/custom_container_time.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reimburse_dialog.dart';

class ContentReport extends StatefulWidget {
  final Function(List<dynamic>) onSelectedItems;

  const ContentReport({super.key, required this.onSelectedItems});

  @override
  State<ContentReport> createState() => ContentReportState();
}

class ContentReportState extends State<ContentReport> {
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
      return []; // Kembalikan list kosong untuk menghindari error
    }
  }

  String formatRupiah(double amount) {
    return 'Rp. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  void refreshData() {
    setState(() {
      _expenseData =
          fetchExpenseData(); // Perbarui Future agar FutureBuilder reload
    });
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
                              Checkbox(
                                value: _selectedItems.contains(item),
                                onChanged: (bool? isSelected) {
                                  setState(() {
                                    if (isSelected == true) {
                                      _selectedItems.add(item);
                                    } else {
                                      _selectedItems.remove(item);
                                    }
                                  });
                                  widget.onSelectedItems(_selectedItems
                                      .map((e) => e['id'])
                                      .toList());
                                },
                              ),
                              SvgPicture.asset('assets/icons/payroll.svg'),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
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
    );
  }
}
