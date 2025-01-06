// activity_detail_dialog.dart

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import '/components/colors.dart';
import 'package:http/http.dart' as http;
import '../../../components/custom_container_time.dart';
import '../../../components/text_style.dart';

class DialogApproval extends StatelessWidget {
  final Map<String, dynamic> activity;
  final Function refreshCallback;

  const DialogApproval(
      {super.key, required this.activity, required this.refreshCallback});

  Future<void> sendApprovalRequest(BuildContext context) async {
    final apiUrl = ApiEndpoints.sendApprovalRequest();
    final method =
        activity['state'] == 'submit' ? 'button_approve1' : 'button_approve';

    final body = {
      "method": method,
      "args": [
        [activity['id']]
      ],
      "kw": {}
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Tampilkan pesan sukses
        final responseData = json.decode(response.body);
        print("Approval successful: $responseData");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Approval successful!')),
        );
        refreshCallback();
        Navigator.of(context).pop();
      } else {
        // Tampilkan pesan gagal
        print("Approval failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Approval failed!')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  Future<void> sendRefuseRequest(BuildContext context) async {
    final apiUrl = ApiEndpoints.sendRefuseRequest();
    const method = 'button_reject';

    final body = {
      "method": method,
      "args": [
        [activity['id']]
      ],
      "kw": {}
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Jika berhasil, refresh halaman dan tutup dialog
        final responseData = json.decode(response.body);
        print("Refuse successful: $responseData");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refuse successful!')),
        );
        refreshCallback();
        Navigator.of(context).pop();
      } else {
        // Tampilkan pesan gagal
        print("Refuse failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refuse failed!')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        activity['description'] ?? 'Detail',
        style: AppTextStyles.displayText_2,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee:', style: AppTextStyles.heading2_1),
          Text('${activity['employee'] ?? '-'}', style: AppTextStyles.heading3),
          Text('Overtime Rule:', style: AppTextStyles.heading2_1),
          Text('${activity['ovt_rule'] ?? '-'}', style: AppTextStyles.heading3),
          Text('Date:', style: AppTextStyles.heading2_1),
          Text('Start Date: ${activity['startDate'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('End Date: ${activity['endDate'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('Create Date: ${activity['createDate'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('State:', style: AppTextStyles.heading2_1),
          Text('${activity['state'] ?? '-'}', style: AppTextStyles.heading3),
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => sendApprovalRequest(context),
                  child: CustomContainerTime(
                    width: 75,
                    height: 30,
                    color: Colors.green[100],
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Approve',
                        style: AppTextStyles.smalBoldlLabel,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => sendRefuseRequest(context),
                  child: CustomContainerTime(
                    width: 75,
                    height: 30,
                    color: AppColors.textdanger,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Refuse',
                        style: AppTextStyles.smalBoldlLabel_2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ],
    );
  }
}
