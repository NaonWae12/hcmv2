// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<Map<String, dynamic>> expenses = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id') ?? 2; // Default to 2 as per API domain
    });

    if (userId != null) {
      fetchExpenses();
    } else {
      print("User ID not found.");
    }
  }

  Future<void> fetchExpenses() async {
    if (userId == null) {
      print("Cannot fetch expenses: userId is null.");
      return;
    }

    String apiUrl =
        "https://jt-hcm.simise.id/api/hr.expense.sheet/search?domain=[('user_id','=',$userId),('state','=','submit')]&fields=[]";

    final headers = {
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("Full JSON data received: $jsonData");

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          setState(() {
            expenses = (jsonData['data'] as List<dynamic>).map((expense) {
              final String createdDate = _formatDate(expense['create_date']);
              return {
                'description': expense['name'] ?? 'No Description',
                'amount': expense['total_amount'] ?? 0,
                // 'currency': (expense['currency_id']?[0]['name']) ?? 'Unknown',
                'createdDate': createdDate,
                'state': expense['state'] ?? 'Unknown',
                'create_date': _formatDate(expense['create_date']),
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
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return '-';
    }
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp0';
    try {
      final formatter =
          NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
      return formatter.format(amount);
    } catch (e) {
      print("Error formatting currency: $e");
      return 'Rp0';
    }
  }

  void refreshActivities() {
    fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: expenses.map((expense) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => DialogApproval(
                      activity: expense, refreshCallback: refreshActivities),
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
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      expense['description'] ??
                                          'No Description',
                                      style: AppTextStyles.heading2_1,
                                    ),
                                    Text(
                                      "Amount: ${_formatCurrency(expense['amount'])}",
                                      style: AppTextStyles.heading3_3,
                                    ),
                                    Text(
                                      "Created: ${expense['createdDate']}",
                                      style: AppTextStyles.heading3_3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              expense['state'] == 'done'
                                  ? 'assets/icons/done.svg'
                                  : 'assets/icons/doc_rev.svg',
                              width: 48.0,
                              height: 48.0,
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
