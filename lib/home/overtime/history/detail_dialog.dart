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
          Text('Date Range:', style: AppTextStyles.heading3_1),
          Text(data['date'] ?? '', style: AppTextStyles.heading3_3),
          Text('Status:', style: AppTextStyles.heading3_1),
          Text(data['state'] ?? 'unknown', style: AppTextStyles.heading3_3),
          Text('Approved 1:', style: AppTextStyles.heading3_1),
          Text(
            data['state'] == 'submit'
                ? 'Not yet'
                : data['state'] == 'approved1'
                    ? (data['approved1'] ?? 'unknown')
                    : (data['approved1'] ?? 'unknown'),
            style: AppTextStyles.heading3_3,
          ),
          Text('Approved 2:', style: AppTextStyles.heading3_1),
          Text(
            data['state'] == 'submit'
                ? 'Not yet'
                : data['state'] == 'approved1'
                    ? 'Not Yet'
                    : (data['approved2'] ?? 'unknown'),
            style: AppTextStyles.heading3_3,
          ),
          Text('Create Date:', style: AppTextStyles.heading3_1),
          Text(data['createDate'] ?? 'unknown',
              style: AppTextStyles.heading3_3),
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
