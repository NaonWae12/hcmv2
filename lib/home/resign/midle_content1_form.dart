import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';

import '../time_off/date_picker_field.dart';

class MidleContent1Form extends StatefulWidget {
  const MidleContent1Form({super.key});

  @override
  State<MidleContent1Form> createState() => _MidleContent1FormState();
}

class _MidleContent1FormState extends State<MidleContent1Form> {
  DateTime? _fromDate;
  Future<void> selectDate(BuildContext context, DateTime? initialDate,
      ValueChanged<DateTime?> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set your resignation date',
              style: AppTextStyles.heading1_1,
            ),
            Text(
              "Set the date for up to 3 months in the future, in accordance with the company's notice period",
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 10),
            DatePickerField(
              label: 'Select the date',
              selectedDate: _fromDate,
              onDateSelected: (newDate) {
                setState(() {
                  _fromDate = newDate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
