import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'content_history.dart';

class PageHistoryPayslip extends StatelessWidget {
  const PageHistoryPayslip({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/appBar_bg_full.png', fit: BoxFit.cover),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      Text(
                        'History Payslip',
                        style: AppTextStyles.heading1_2,
                      ),
                      const SizedBox(width: 40)
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: PrimaryContainer(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: const ContentHistory(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
