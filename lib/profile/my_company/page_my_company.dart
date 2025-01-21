import 'package:flutter/material.dart';
import 'package:hcm_3/components/colors.dart';
import 'package:hcm_3/components/primary_container.dart';
import 'package:hcm_3/components/text_style.dart';

class PageMyCompany extends StatelessWidget {
  const PageMyCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'My Company',
          style: AppTextStyles.headingStyle,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Company Profile',
              style: AppTextStyles.headingStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CircleAvatar(
              radius: 60,
              child: Image.asset('assets/3.png'),
            ),
          ),
          Text(
            'PT Jakarana Tama',
            style: AppTextStyles.headingStyle,
          ),
          const SizedBox(height: 20),
          PrimaryContainer(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: AppTextStyles.heading1_1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        color: AppColors.textdanger,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Location :',
                        style: AppTextStyles.heading2_4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 70, 70, 70),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Phone   :',
                        style: AppTextStyles.heading2_4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Email   :',
                        style: AppTextStyles.heading2_4,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
