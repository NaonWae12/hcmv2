import 'package:flutter/material.dart';
import '../../../components/primary_container.dart';
import '../../../components/text_style.dart';
import '../../time_off/date_picker_field.dart';

class BottomContent2 extends StatefulWidget {
  const BottomContent2({super.key});

  @override
  State<BottomContent2> createState() => BottomContent2State();
}

class BottomContent2State extends State<BottomContent2> {
  DateTime? _fromDate1;
  DateTime? _fromDate2;

  DateTime? get fromDate1 => _fromDate1; // Tambahkan getter ini
  DateTime? get fromDate2 => _fromDate2; // Tambahkan getter ini
  void reset() {
    setState(() {
      _fromDate1 = null;
      _fromDate2 = null;
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
              'Set the duration',
              style: AppTextStyles.heading2_1,
            ),
            Text(
              'Start date',
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
              enableTimePicker: true,
            ),
            const SizedBox(height: 8),
            Text(
              'End date',
              style: AppTextStyles.heading2_1,
            ),
            DatePickerField(
              label: 'Select date',
              selectedDate: _fromDate2,
              onDateSelected: (newDate) {
                setState(() {
                  _fromDate2 = newDate;
                });
              },
              enableTimePicker: true,
            ),
          ],
        ),
      ),
    );
  }
}
