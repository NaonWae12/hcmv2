import 'package:flutter/material.dart';
import '../../components/text_style.dart';

class ReimburseDialog extends StatelessWidget {
  final String name;
  final String date;
  final String amount;
  final String productName;

  const ReimburseDialog({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reimburse Details',
        style: AppTextStyles.heading2_1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description: $name',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Date: $date',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Amount: $amount',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Category: $productName',
            style: AppTextStyles.heading3,
          ),
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
