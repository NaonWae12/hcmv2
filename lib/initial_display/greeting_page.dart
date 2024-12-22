import 'package:flutter/material.dart';
import '/components/primary_button.dart';
import '../components/text_style.dart';
import 'page_login.dart';

class GreetingPage extends StatelessWidget {
  const GreetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Back!', style: AppTextStyles.displayText_2),
            Image.asset('assets/Team.gif'),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text(
                "We're here to support you in working more efficiently and reaching your goals with ease. Stay motivated, and let's make today a productive and fulfilling day together!",
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/3.png',
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PT. Jakarana Tama',
                      style: AppTextStyles.heading3,
                    ),
                    Text(
                      'Food Industry',
                      style: AppTextStyles.heading3,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              buttonWidth: MediaQuery.of(context).size.width / 1.5,
              buttonHeight: 50,
              buttonText: 'Go to Sign In',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const PageLogin()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
