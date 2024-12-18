import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';

class BottomContentForm extends StatelessWidget {
  const BottomContentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload resign letter',
              style: AppTextStyles.heading2_1,
            ),
            Text(
              'Company requires a resignation letter to assess the seriousness of the decision to resign.',
              style: AppTextStyles.heading2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0, // Hilangkan bayangan tombol
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Upload files',
                        style: GoogleFonts.quicksand(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
