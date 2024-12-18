import 'package:flutter/material.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';

import 'resignation_bottom_sheet.dart';

class PageResignationRequest extends StatelessWidget {
  const PageResignationRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Resign',
              style: AppTextStyles.heading1_1,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/resign_check.png',
                height: 180,
                width: 180,
              ),
              Text(
                  "Fiuh... you haven’t submit any resign letter. Be happy on your work!",
                  style: AppTextStyles.heading1_3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip),
              const Spacer(),
              PrimaryButton(
                buttonWidth: MediaQuery.of(context).size.width,
                buttonHeight: 50,
                buttonText: 'Submit Resign Letter',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return const ResignationBottomSheet();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}
