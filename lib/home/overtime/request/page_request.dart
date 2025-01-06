// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/primary_button.dart';
import 'bottom_content_2.dart';
import 'dialog_utils.dart';
import 'midle_content.dart';
import 'nav_submited.dart';
import 'submited/page_submit_ovt.dart';
import 'top_content.dart';

class PageRequest extends StatefulWidget {
  const PageRequest({super.key});

  @override
  State<PageRequest> createState() => _PageRequestState();
}

class _PageRequestState extends State<PageRequest> {
  final GlobalKey<TopContentState> _topContentKey =
      GlobalKey<TopContentState>();
  final GlobalKey<MidleContentState> _midleContentKey =
      GlobalKey<MidleContentState>();
  final GlobalKey<BottomContent2State> _bottomContent2Key =
      GlobalKey<BottomContent2State>();

  Future<int?> _getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employee_id');
  }

  Future<void> _createRequest() async {
    try {
      // Ambil data dari masing-masing widget
      final ruleId = _topContentKey.currentState?.selectedRule;
      final reasonId = _midleContentKey.currentState?.selectedReason;
      final startDate = _bottomContent2Key.currentState?.fromDate1;
      final endDate = _bottomContent2Key.currentState?.fromDate2;

      if (ruleId == null ||
          reasonId == null ||
          startDate == null ||
          endDate == null) {
        throw Exception('Please complete all fields.');
      }

      // Ambil employee_id dari SharedPreferences
      final employeeId = await _getEmployeeId();
      if (employeeId == null) {
        throw Exception('Employee ID not found.');
      }

      // Format tanggal sesuai request body
      final formattedStartDate = startDate.toUtc().toIso8601String();
      final formattedEndDate = endDate.toUtc().toIso8601String();

      // Request body
      final body = {
        "rule_id": int.parse(ruleId),
        "reason_id": int.parse(reasonId),
        "employee_id": employeeId,
        "req_start": formattedStartDate,
        "req_end": formattedEndDate,
      };

      String apiUrl = ApiEndpoints.createRequest();
      const Map<String, String> headers = {
        "Content-Type": "application/json",
        'api-key': ApiConfig.apiKey
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Tampilkan dialog sukses
        DialogUtils.showSuccessDialog(context, 'Request created successfully!');

        // Reset semua inputan
        _topContentKey.currentState?.reset();
        _midleContentKey.currentState?.reset();
        _bottomContent2Key.currentState?.reset();

        // Navigasi ke PageSubmitOvt setelah sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageSubmitOvt()),
        );
      } else {
        DialogUtils.showErrorDialog(context,
            'Failed to create request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopContent(key: _topContentKey),
          const SizedBox(height: 10),
          MidleContent(key: _midleContentKey),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          BottomContent2(key: _bottomContent2Key),
          const SizedBox(height: 10),
          const NavSubmited(),
          PrimaryButton(
            buttonWidth: MediaQuery.of(context).size.width / 1.2,
            buttonText: 'Create Request',
            onPressed: _createRequest,
          ),
        ],
      ),
    );
  }
}
