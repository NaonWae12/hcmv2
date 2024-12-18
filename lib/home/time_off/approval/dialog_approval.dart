// activity_detail_dialog.dart

import 'package:flutter/material.dart';
import '/components/colors.dart';

import '../../../components/custom_container_time.dart';
import '../../../components/text_style.dart';

class DialogApproval extends StatelessWidget {
  final Map<String, dynamic> activity;

  const DialogApproval({super.key, required this.activity});

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
          Text('Start Date: ${activity['startDate'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('End Date: ${activity['endDate'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('Descriptions: ${activity['private_name'] ?? '-'}',
              style: AppTextStyles.heading3),
          Text('Duration: ${activity['duration_display'] ?? '-'}',
              style: AppTextStyles.heading3),
          // Add any other details you want to display here
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainerTime(
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
                CustomContainerTime(
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
