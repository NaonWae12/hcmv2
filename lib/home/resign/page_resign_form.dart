import 'package:flutter/material.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';

import 'bottom_content_form.dart';
import 'midle_content1_form.dart';
import 'midle_content2_form.dart';

class PageResignForm extends StatelessWidget {
  const PageResignForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            Text(
              'Resign',
              style: AppTextStyles.heading1_1,
            ),
            const SizedBox(width: 40),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MidleContent1Form(),
            const SizedBox(height: 10),
            const MidleContent2Form(),
            const SizedBox(height: 10),
            const BottomContentForm(),
            const SizedBox(height: 15),
            PrimaryButton(
              buttonWidth: MediaQuery.of(context).size.width / 1.15,
              buttonHeight: 45,
              buttonText: 'Submit',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
