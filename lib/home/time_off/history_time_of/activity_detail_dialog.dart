import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/text_style.dart';
import 'webview_page.dart';

class ActivityDetailDialog extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailDialog({super.key, required this.activity});

  String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '-';
    }

    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return '-'; // Handle parsing errors gracefully
    }
  }

  void _openInWebView(BuildContext context, String url, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: url,
          description: description, // Tambahkan description
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Validasi awal untuk memastikan data `activity` valid
    if (activity.isEmpty) {
      return AlertDialog(
        title: const Text('Invalid Activity'),
        content: const Text('No details available for this activity.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    }

    // Ambil attachment_ids dari activity
    final List<int> attachmentIds =
        (activity['attachment_ids'] as List<dynamic>?)?.map((attachment) {
              if (attachment is int) {
                return attachment; // Jika langsung berupa int
              } else if (attachment is Map<String, dynamic>) {
                return attachment['id']
                    as int; // Jika berupa objek dengan properti 'id'
              } else {
                throw TypeError(); // Tangani tipe data yang tidak sesuai
              }
            }).toList() ??
            [];

    return AlertDialog(
      title: Text(
        activity['description'] ?? 'Detail',
        style: AppTextStyles.displayText_2,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Date: ${formatDate(activity['create_date'])}',
                style: AppTextStyles.heading3),
            Text('Start Date: ${activity['startDate'] ?? '-'}',
                style: AppTextStyles.heading3),
            Text('End Date: ${activity['endDate'] ?? '-'}',
                style: AppTextStyles.heading3),
            Text('Descriptions: ${activity['private_name'] ?? '-'}',
                style: AppTextStyles.heading3),
            Text('Duration: ${activity['duration_display'] ?? '-'}',
                style: AppTextStyles.heading3),
            Text('Status: ${activity['state'] ?? '-'}',
                style: AppTextStyles.heading3),
            const SizedBox(height: 10),
            if (attachmentIds.isNotEmpty) ...[
              Text('Attachments:', style: AppTextStyles.heading3),
              ...attachmentIds.map((id) {
                return InkWell(
                  onTap: () {
                    final fileUrl = "https://jt-hcm.simise.id/web/content/$id";
                    final description =
                        activity['description'] ?? 'WebView'; // Ambil deskripsi
                    _openInWebView(context, fileUrl, description);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Attachment $id',
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
                // ignore: unnecessary_to_list_in_spreads
              }).toList(),
            ] else
              Text('No Attachments', style: AppTextStyles.heading3),
          ],
        ),
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
