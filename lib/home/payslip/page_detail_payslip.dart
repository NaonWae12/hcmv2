// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_loading.dart';
import '/components/primary_button.dart';
import '/components/secondary_container.dart';
import '/components/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

import 'history/page_history_payslip.dart';

class PageDetailPayslip extends StatelessWidget {
  const PageDetailPayslip({super.key});

  Future<Map<String, dynamic>?> _fetchLatestSlipId(int employeeId) async {
    final apiUrl = ApiEndpoints.fetchLatestSlipId(employeeId);
    const headers = {
      'Content-Type': 'application/json',
      'api-key': ApiConfig.apiKey
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> payslipData = jsonResponse['data'] ?? [];

        if (payslipData.isNotEmpty) {
          payslipData.sort((a, b) {
            final dateA = DateTime.parse(a['payslip_date'] ?? a['create_date']);
            final dateB = DateTime.parse(b['payslip_date'] ?? b['create_date']);
            return dateB.compareTo(dateA); // Sort descending
          });

          final latestPayslip = payslipData.first;
          return {
            'id': latestPayslip['id'], // ID of the latest payslip
            'payslip_date': latestPayslip['payslip_date'], // Payslip date
          };
        }
      } else {
        print(
            "Failed to fetch payslip data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching latest payslip ID: $e");
    }
    return null;
  }

  Future<List<dynamic>> _fetchPayslipData(int employeeId) async {
    final latestSlip = await _fetchLatestSlipId(employeeId);
    if (latestSlip == null) return [];

    final apiUrl =
        'https://jt-hcm.simise.id/api/hr.payslip.line/search?domain=[(\'slip_id\',\'=\',${latestSlip['id']})]&fields=[\'name\',\'amount\',\'category_id\']';
    const headers = {
      'Content-Type': 'application/json',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'] ?? [];
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching payslip data: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> _getEmployeeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeId = prefs.getInt('employee_id') ?? 0;
    final name = prefs.getString('name') ?? 'Unknown';
    final jobId = prefs.getString('job_id') ?? 'Unknown';
    return {
      'employee_id': employeeId,
      'name': name,
      'job_id': jobId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getEmployeeDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoading(imagePath: 'assets/3.png'));
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Failed to load employee details'));
        } else {
          final employeeDetails = snapshot.data!;
          final employeeId = employeeDetails['employee_id'];
          final name = employeeDetails['name'];
          final jobId = employeeDetails['job_id'];

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Text(
                    'Payslip',
                    style: AppTextStyles.heading1_1,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageHistoryPayslip(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history_edu_sharp),
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: FutureBuilder<Map<String, dynamic>?>(
              future: _fetchLatestSlipId(employeeId),
              builder: (context, latestSlipSnapshot) {
                if (latestSlipSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CustomLoading(imagePath: 'assets/3.png'));
                } else if (latestSlipSnapshot.hasError ||
                    latestSlipSnapshot.data == null) {
                  return const Center(
                      child: Text('Failed to load latest payslip'));
                } else {
                  final latestSlip = latestSlipSnapshot.data!;
                  final payslipDate =
                      latestSlip['payslip_date'] ?? 'Unknown Date';

                  return FutureBuilder<List<dynamic>>(
                    future: _fetchPayslipData(employeeId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CustomLoading(imagePath: 'assets/3.png'));
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Failed to load data'));
                      } else {
                        final data = snapshot.data ?? [];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              children: [
                                _buildPayslipDetail(
                                    context, data, name, jobId, payslipDate),
                                const SizedBox(height: 10),
                                PrimaryButton(
                                  buttonWidth:
                                      MediaQuery.of(context).size.width / 1.4,
                                  buttonText: 'Preview',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildPayslipDetail(BuildContext context, List<dynamic> data,
      String name, String jobId, String payslipDate) {
    final earnings =
        _filterDataByCategory(data, ['Allowance', 'Company Contributions']);
    final deductions = _filterDataByCategory(data, ['Deduction']);
    final gross = _filterDataByCategory(data, ['Gross']).firstOrNull;
    final netSalary = _filterDataByCategory(data, ['Net']).firstOrNull;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/payslip_detail.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, name, jobId),
            const SizedBox(height: 10),
            _buildMonthRow(context, payslipDate),
            const SizedBox(height: 70),
            _buildSectionTitle('Penghasilan'),
            _buildItems(context, earnings),
            if (gross != null)
              _buildSummaryRow(
                  context, 'Bruto', "Rp${_formatCurrency(gross['amount'])}"),
            const Divider(color: Colors.grey),
            _buildSectionTitle('Potongan'),
            _buildItems(context, deductions),
            const Divider(color: Colors.grey),
            if (netSalary != null)
              _buildSummaryRow(context, 'Net Salary',
                  "Rp${_formatCurrency(netSalary['amount'])}"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String jobId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 77,
              width: 77,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.heading1),
                Text(jobId, style: AppTextStyles.heading1),
                Text('DE3824-MO4', style: AppTextStyles.heading3_3),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            const url = 'https://jt-hcm.simise.id/web/content/4001';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            }
          },
          icon: const Icon(
            Icons.download_for_offline_outlined,
            size: 45,
            color: Colors.white60,
          ),
        )
      ],
    );
  }

  Widget _buildMonthRow(BuildContext context, String payslipDate) {
    final formattedDate = DateTime.parse(payslipDate);
    final month = _formatMonth(formattedDate.month);
    final year = formattedDate.year;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "DEC",
          // month.toUpperCase(),
          style: AppTextStyles.heading1,
        ),
        SecondaryContainer(
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: Text(
              '$month $year',
              style: AppTextStyles.heading1_1,
            ),
          ),
        ),
      ],
    );
  }

  String _formatMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Widget _buildItems(BuildContext context, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => _buildSummaryRow(
                  context,
                  item['name'] ?? 'N/A',
                  "Rp${_formatCurrency(item['amount'] ?? 0)}",
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.2,
            child: Text(
              label,
              style: AppTextStyles.heading1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 130),
            width: MediaQuery.of(context).size.width / 3.3,
            child: Text(
              value,
              style: AppTextStyles.heading1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterDataByCategory(
      List<dynamic> data, List<String> categories) {
    return data
        .where((item) =>
            item['category_id']?.first['name'] != null &&
            categories.contains(item['category_id']?.first['name']))
        .toList();
  }

  String _formatCurrency(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }
}
