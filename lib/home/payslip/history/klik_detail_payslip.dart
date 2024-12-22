// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/components/primary_button.dart';
import '/components/secondary_container.dart';
import '/components/text_style.dart';

class KlikDetailPayslip extends StatelessWidget {
  final Map<String, dynamic> slipData;

  const KlikDetailPayslip({super.key, required this.slipData});

  Future<List<dynamic>> _fetchPayslipData(int slipId) async {
    final apiUrl =
        'https://jt-hcm.simise.id/api/hr.payslip.line/search?domain=[(\'slip_id\',\'=\',$slipId)]&fields=[\'name\',\'amount\',\'category_id\']';
    const headers = {
      'Content-Type': 'application/json',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'] ?? [];
      }
    } catch (e) {
      print("Error while fetching payslip details: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final payslipDate = slipData['payslip_date'] ?? 'Unknown Date';
    // final slipName = slipData['name'] ?? 'Unknown Slip Name';
    final slipNumber = slipData['number'] ?? 'Unknown Slip Number';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              'Payslip',
              style: AppTextStyles.heading1_1,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/payslip_detail.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        context,
                        slipNumber,
                      ),
                      const SizedBox(height: 10),
                      _buildMonthRow(context, payslipDate),
                      const SizedBox(height: 70),
                      FutureBuilder<List<dynamic>>(
                        future: _fetchPayslipData(slipData['id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const Center(
                                child: Text('Failed to load payslip details'));
                          } else {
                            final payslipDetails = snapshot.data!;
                            return _buildPayslipDetail(context, payslipDetails);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                buttonWidth: MediaQuery.of(context).size.width / 1.4,
                buttonText: 'Preview',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String slipNumber) {
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
                FutureBuilder<String?>(
                  future: _getNameFromSharedPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Tampilkan loading saat data belum siap
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text(
                        "Unknown Name",
                        style: AppTextStyles.heading1,
                      );
                    } else {
                      return Text(
                        snapshot.data!,
                        style: AppTextStyles.heading1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
                Text(
                  slipNumber,
                  style: AppTextStyles.heading1,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            // const url = 'https://jt-hcm.simise.id/web/content/4001';
            // if (await canLaunchUrl(Uri.parse(url))) {
            //   await launchUrl(Uri.parse(url),
            //       mode: LaunchMode.externalApplication);
            // }
          },
          icon: const Icon(
            Icons.download_for_offline_outlined,
            size: 45,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Future<String?> _getNameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
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

  Widget _buildPayslipDetail(BuildContext context, List<dynamic> data) {
    final earnings =
        _filterDataByCategory(data, ['Allowance', 'Company Contributions']);
    final deductions = _filterDataByCategory(data, ['Deduction']);
    final gross = _filterDataByCategory(data, ['Gross']).firstOrNull;
    final netSalary = _filterDataByCategory(data, ['Net']).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading1,
      overflow: TextOverflow.ellipsis,
    );
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

  String _formatCurrency(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }
}
