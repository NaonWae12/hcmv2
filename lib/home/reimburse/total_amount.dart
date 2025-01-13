import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/components/primary_container.dart';

import '../../components/text_style.dart';

class TotalAmount extends StatefulWidget {
  const TotalAmount({super.key});

  @override
  State<TotalAmount> createState() => TotalAmountState();
}

class TotalAmountState extends State<TotalAmount> {
  final TextEditingController _controller = TextEditingController();
  String get formattedAmount => _controller.text;

  /// Reset state dan controller
  void resetData() {
    setState(() {
      _controller.clear(); // Mengosongkan teks dalam controller
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Membersihkan controller
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return "Rp. ";
    value = value.replaceAll(RegExp(r'[^0-9]'), ''); // Hanya angka
    int number = int.tryParse(value) ?? 0;
    String formatted = number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
    return "Rp. $formatted";
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input amount',
              style: AppTextStyles.heading2_1,
            ),
            TextField(
              controller: _controller,
              style: AppTextStyles.heading2_5,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  _controller.value = TextEditingValue(
                    text: _formatCurrency(value),
                    selection: TextSelection.collapsed(
                        offset: _formatCurrency(value).length),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
