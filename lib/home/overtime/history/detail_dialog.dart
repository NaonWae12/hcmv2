import 'package:flutter/material.dart';
import '../../../components/text_style.dart'; // Sesuaikan dengan lokasi file AppTextStyles

class DetailDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Detail History',
        style: AppTextStyles.heading2_1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason:', style: AppTextStyles.heading3_1),
          Text(data['reason'] ?? 'Unknown Reason',
              style: AppTextStyles.heading3_3),
          Text('Rule:', style: AppTextStyles.heading3_1),
          Text(data['rule'] ?? 'Unknown Reason',
              style: AppTextStyles.heading3_3),
          const SizedBox(height: 8.0),
          Text('Date Range:', style: AppTextStyles.heading3_1),
          Text(data['date'] ?? '', style: AppTextStyles.heading3_3),
          const SizedBox(height: 8.0),
          Text('State:', style: AppTextStyles.heading3_1),
          Text(data['state'] ?? 'unknown', style: AppTextStyles.heading3_3),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}