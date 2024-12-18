import 'package:flutter/material.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';

class ResignationBottomSheet extends StatefulWidget {
  const ResignationBottomSheet({super.key});

  @override
  State<ResignationBottomSheet> createState() => _ResignationBottomSheetState();
}

class _ResignationBottomSheetState extends State<ResignationBottomSheet> {
  bool isChecked = false;
  List<bool> iconCheckList = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Read this carefully before submitting your resignation letter',
              style: AppTextStyles.heading1_1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildCheckItem(
              'You are required to provide a notice period as stipulated in your contract.',
              0,
            ),
            _buildCheckItem(
              'You are encouraged to participate in an exit interview to provide valuable feedback.',
              1,
            ),
            _buildCheckItem(
              'You must return all company property, including but not limited to access cards, etc.',
              2,
            ),
            _buildCheckItem(
              'You are required to complete the clearance procedure as outlined by the HR department.',
              3,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'By submitting your resignation, you acknowledge that you have read and understood the terms and conditions outlined above',
                    style: AppTextStyles.heading2_4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PrimaryButton(
                  buttonText: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                PrimaryButton(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                  elevation: 0,
                  buttonText: 'Yes, I Will',
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                iconCheckList[index] =
                    !iconCheckList[index]; // Toggle icon state
              });
            },
            child: Icon(
              iconCheckList[index]
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.heading2,
            ),
          ),
        ],
      ),
    );
  }
}
