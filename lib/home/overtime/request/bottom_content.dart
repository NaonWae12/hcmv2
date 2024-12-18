//tidak digunakan
import 'package:flutter/material.dart';

import '../../../components/primary_container.dart';
import '../../../components/text_style.dart';
import '../../../components/textfield_input.dart';

class BottomContent extends StatefulWidget {
  const BottomContent({super.key});

  @override
  State<BottomContent> createState() => _BottomContentState();
}

class _BottomContentState extends State<BottomContent> {
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      width: MediaQuery.of(context).size.width,
      borderRadius: BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: AppTextStyles.heading2_1),
            const SizedBox(height: 8),
            const TextfieldInput(
              hintText: 'Write your description here..',
              borderSide: BorderSide(),
            ),
          ],
        ),
      ),
    );
  }
}
