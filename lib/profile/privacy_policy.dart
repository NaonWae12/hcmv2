import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan package ini di pubspec.yaml jika belum

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  // Membuat TextStyle yang digunakan dalam aplikasi
  TextStyle headingStyle(double fontSize) => GoogleFonts.quicksand(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: Colors.black,
      );

  TextStyle bodyStyle(double fontSize) => GoogleFonts.quicksand(
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        color: Colors.black87,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: headingStyle(20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Introduction'),
            _buildBodyText(
              'We value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and protect the information you provide when using the Mobile HR application. By using the app, you agree to the terms outlined in this Privacy Policy.',
            ),
            _buildSectionTitle('2. Information We Collect'),
            _buildBodyText('We collect the following types of information:'),
            _buildBodyText(
              '''• Personal Information: Includes your name, email address, employee ID, department, and other HR-related details.
• Usage Data: Information about how you interact with the application, such as login timestamps and feature usage.
• Device Information: Includes device type, operating system, unique device identifiers, and IP address.''',
            ),
            _buildSectionTitle('3. How We Use Your Information'),
            _buildBodyText(
              '''Your information is used to:
• Manage HR functions such as attendance, leave requests, and payroll processing.
• Provide support and enhance the functionality of the application.
• Ensure compliance with company policies and legal requirements.''',
            ),
            _buildSectionTitle('4. Data Sharing and Disclosure'),
            _buildBodyText(
              '''We do not share your personal data with third parties except in the following cases:
• With authorized service providers to support the application’s functionality.
• When required by law, regulation, or legal process.
• To protect the rights and safety of the company or its employees.''',
            ),
            _buildSectionTitle('5. Data Security'),
            _buildBodyText(
              'We implement industry-standard security measures to protect your personal data from unauthorized access, alteration, disclosure, or destruction. However, no system is completely secure, and we cannot guarantee absolute security.',
            ),
            _buildSectionTitle('6. Retention of Data'),
            _buildBodyText(
              'We retain your personal information as long as necessary to fulfill the purposes outlined in this policy or as required by law.',
            ),
            _buildSectionTitle('7. Your Rights'),
            _buildBodyText(
              '''You have the right to:
• Access your personal data stored in the application.
• Request corrections to your personal data.
• Request deletion of your personal data, subject to legal and operational requirements.''',
            ),
            _buildSectionTitle('8. Cookies and Tracking Technologies'),
            _buildBodyText(
              'The application may use cookies or similar technologies to improve user experience. By using the app, you consent to their use as described.',
            ),
            _buildSectionTitle('9. Changes to This Privacy Policy'),
            _buildBodyText(
              'We may update this Privacy Policy from time to time. Any changes will be communicated through the application, and continued use of the app constitutes acceptance of the revised policy.',
            ),
            _buildSectionTitle('10. Contact Information'),
            _buildBodyText(
              '''For questions or concerns regarding this Privacy Policy, please contact:
IT Department
[Your Company Name]
Email: [Insert Email Address]
Phone: [Insert Phone Number]''',
            ),
            const SizedBox(height: 16),
            _buildBodyText(
              'By using the Mobile HR application, you acknowledge that you have read and understood this Privacy Policy and agree to its terms.',
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat teks judul bagian
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: headingStyle(18)),
    );
  }

  // Fungsi untuk membuat teks isi
  Widget _buildBodyText(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(content, style: bodyStyle(14)),
    );
  }
}
