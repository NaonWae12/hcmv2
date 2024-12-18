// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';

import 'date_picker_field.dart';

class MidleContent1 extends StatefulWidget {
  const MidleContent1({super.key});

  @override
  State<MidleContent1> createState() => MidleContent1State();
}

class MidleContent1State extends State<MidleContent1> {
  DateTime? _fromDate1;
  DateTime? _fromDate2;

  // Mengubah totalAllocated dan totalUsed menjadi nullable (int?)
  int? totalAllocated;
  int? totalUsed;
  int? remainingTimeOff; // Mengubah remainingTimeOff menjadi nullable

  DateTime? get fromDate1 => _fromDate1;
  DateTime? get fromDate2 => _fromDate2;

  // Update method untuk memperbarui allocated dan used
  void updateAllocatedUsed(int? allocated, int? used) {
    setState(() {
      totalAllocated = allocated;
      totalUsed = used;

      // Jika salah satu data null, jangan lakukan perhitungan
      // Lakukan perhitungan jika data valid
      if (totalAllocated != null && totalUsed != null) {
        remainingTimeOff = totalAllocated! - totalUsed!;
      } else {
        remainingTimeOff = 0; // Set remainingTimeOff ke 0 jika data null
      }
    });
  }

  // Method untuk menghitung sisa waktu cuti
  int calculateRemainingTimeOff() {
    if (totalAllocated != null && totalUsed != null) {
      return totalAllocated! - totalUsed!;
    } else {
      return 0; // Return 0 jika data null
    }
  }

  // Method untuk menampilkan dialog peringatan jika jumlah hari lebih dari sisa waktu cuti
  void showExceededTimeOffDialog() {
    // Pastikan remainingTimeOff tidak null sebelum menampilkan dialog
    if (totalAllocated != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Time Off Exceeds Available Days'),
          content: const Text(
              'The selected dates exceed your available time off. Please adjust the dates.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void reset() {
    setState(() {
      _fromDate1 = null;
      _fromDate2 = null;
      totalAllocated = null;
      totalUsed = null;
      remainingTimeOff = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update remaining time off setelah total allocated dan used diset
    remainingTimeOff = calculateRemainingTimeOff();

    // Mengecek apakah rentang waktu melebihi sisa waktu cuti setelah memilih tanggal
    if (_fromDate1 != null && _fromDate2 != null) {
      final int selectedDays = _fromDate2!.difference(_fromDate1!).inDays + 1;
      if (selectedDays > remainingTimeOff!) {
        // Menampilkan dialog jika rentang waktu lebih dari sisa waktu cuti
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showExceededTimeOffDialog();
        });
      }
    }

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
            ),
            // Hanya tampilkan pesan jika data valid
            if (remainingTimeOff != null && remainingTimeOff! <= 0)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '',
                  // 'You do not have any remaining time off.',
                  style: TextStyle(color: Colors.red),
                ),
              )
            else if (remainingTimeOff != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'You have $remainingTimeOff days left.',
                  style: const TextStyle(color: Colors.green),
                ),
              ), // Jika totalAllocated atau totalUsed null, jangan tampilkan teks
          ],
        ),
      ),
    );
  }
}
