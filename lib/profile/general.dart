// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
import '../components/primary_container.dart';
import '../components/text_style.dart';
import 'pin_settings/page_pin_settings.dart';
// import '../theme_provider.dart';

class General extends StatelessWidget {
  General({super.key});

  final List<Map<String, dynamic>> settingsItems = [
    // {
    //   'icon': 'assets/icons/profile_rounded.svg',
    //   'title': 'Account Setting',
    //   'page': const AccountSettingsPage(),
    // },
    {
      'icon': 'assets/icons/bell_rounded.svg',
      'title': 'Notification',
      'page': const NotificationSettingsPage(),
    },
    {
      'icon': 'assets/icons/lock_password_rounded.svg',
      'title': 'Set up your PIN',
      'page': const PagePinSettings(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // final themeProvider =
    //     Provider.of<ThemeProvider>(context); // Access the provider

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: PrimaryContainer(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Column(
              children: [
                ...settingsItems.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        leading: SvgPicture.asset(
                          item['icon'],
                          color: Theme.of(context).colorScheme.primary,
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
                                builder: (context) => item['page']),
                          );
                        },
                      ),
                    ],
                  );
                }),
                // ListTile(
                //   leading: const Icon(Icons.dark_mode),
                //   title: const Text('Dark Mode'),
                //   trailing: Switch(
                //     value: themeProvider.themeMode == ThemeMode.dark,
                //     onChanged: (bool value) {
                //       themeProvider.toggleTheme(value);
                //     },
                //   ),
                // ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

// class AccountSettingsPage extends StatelessWidget {
//   const AccountSettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Account Settings'),
//       ),
//       body: const Center(
//         child: Text('Account Settings Page'),
//       ),
//     );
//   }
// }

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: const Center(
        child: Text('Notification Settings Page'),
      ),
    );
  }
}

class FaceVerificationPage extends StatelessWidget {
  const FaceVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: const Center(
        child: Text('Face Verification Page'),
      ),
    );
  }
}

// class PinSettingsPage extends StatelessWidget {
//   const PinSettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Set up your PIN'),
//       ),
//       body: const Center(
//         child: Text('Set up your PIN Page'),
//       ),
//     );
//   }
// }


