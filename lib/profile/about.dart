import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/primary_container.dart';
import '../components/text_style.dart';
import 'logout_tile.dart';
import 'privacy_policy.dart';

class About extends StatelessWidget {
  About({super.key});

  final List<Map<String, dynamic>> settingsItems = [
    {
      'icon': 'assets/icons/note_text_rounded.svg',
      'title': 'Privacy Policy',
      'page': const PrivacyPolicy(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: PrimaryContainer(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Column(
                children: [
                  ...settingsItems.map((item) {
                    return Column(
                      children: [
                        ListTile(
                          leading: SvgPicture.asset(
                            item['icon'],
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.primary,
                            height: 24.0,
                            width: 24.0,
                          ),
                          title: Text(
                            item['title'],
                            style: AppTextStyles.heading2_4,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item['page'],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                  const LogoutTile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
