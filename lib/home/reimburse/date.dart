import 'package:flutter/material.dart';

import '../../components/primary_container.dart';
import '../../components/text_style.dart';
import '../time_off/date_picker_field.dart';

class Date extends StatefulWidget {
  const Date({super.key});

  @override
  State<Date> createState() => DateState();
}

class DateState extends State<Date> {
  DateTime? _fromDate1;
  DateTime? get selectedDate => _fromDate1;

  void resetSelectedDate() {
    setState(() {
      _fromDate1 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set the date',
              style: AppTextStyles.heading2_1,
            ),
            DatePickerField(
              label: 'Select date',
              selectedDate: _fromDate1,
              onDateSelected: (newDate) {
                setState(() {
                  _fromDate1 = newDate;
                });
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
