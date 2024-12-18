// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navbar.dart';
import 'content_login.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');

    if (sessionId != null) {
      // Jika session_id ditemukan, arahkan langsung ke Navbar
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/appBar_bg_full.png', fit: BoxFit.cover),
          Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/3.png',
                height: 50,
              ),
              Text(
                "PT. Jakarana Tama",
                style: AppTextStyles.heading3_3,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                child: Text(
                  "Let’s get you sign in and we will make your work life smoother, together.",
                  style: AppTextStyles.heading3_3,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PrimaryContainer(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: const ContentLogin(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
