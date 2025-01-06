// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/primary_button.dart';
import '../../../components/text_style.dart';
import '../dialog_utils.dart';
import 'content_report.dart';
import 'submit_report/page_submit_report.dart';

class PageCreateReport extends StatefulWidget {
  const PageCreateReport({super.key});

  @override
  State<PageCreateReport> createState() => _PageCreateReportState();
}

class _PageCreateReportState extends State<PageCreateReport> {
  List<dynamic> _selectedExpenseIds = [];

  // Key untuk me-refresh ContentReport
  final GlobalKey<ContentReportState> _contentReportKey =
      GlobalKey<ContentReportState>();

  /// Fungsi untuk merefresh ContentReport
  void refreshContent() {
    setState(() {
      // Trigger refresh pada ContentReport
      _contentReportKey.currentState?.refreshData();
    });
  }

  /// Fungsi submit data
  void _submitData() async {
    if (_selectedExpenseIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No expenses selected!')),
      );
      return;
    }

    final url = Uri.parse('https://jt-hcm.simise.id/api/hr.expense/execute_kw');
    final headers = {
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
      'Content-Type': 'application/json'
    };
    final body = {
      "method": "action_submit_expenses",
      "args": [_selectedExpenseIds],
      "kw": {}
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Tampilkan dialog sukses
        DialogUtils.showSuccessDialog(
          context,
          'Data successfully submitted!',
          onOkPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageSubmitReport(),
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to send data: ${response.body}');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Report', style: AppTextStyles.heading1_1),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageSubmitReport(),
                  ),
                );
              },
              icon: const Icon(Icons.approval))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ContentReport(
              key: _contentReportKey,
              onSelectedItems: (selectedIds) {
                setState(() {
                  _selectedExpenseIds = selectedIds;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            buttonWidth: MediaQuery.of(context).size.width / 1.5,
            buttonText: 'Create',
            onPressed: _submitData,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
