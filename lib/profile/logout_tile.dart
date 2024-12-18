// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/text_style.dart';
import '../initial_display/page_login.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Gunakan Future.delayed untuk memastikan konteks tetap sinkron
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const PageLogin()),
      );
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _logout(context); // Execute logout
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        'assets/icons/logout_rounded.svg',
        color: Theme.of(context).colorScheme.primary,
        height: 24.0,
        width: 24.0,
      ),
      title: Text(
        'Logout',
        style: AppTextStyles.heading2_4,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showLogoutConfirmationDialog(context),
    );
  }
}
