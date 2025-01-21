import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.textLight2,
    ),
  );
  static TextStyle heading1_1 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle heading1_2 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark1),
  );
  static TextStyle heading1_3 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  );
  static TextStyle heading2 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textLight2, //static color
      //used
      //Today’s Overview
    ),
  );
  static TextStyle heading2_1 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle heading2_3 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
  );
  static TextStyle heading2_4 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
  static TextStyle heading2_5 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryColor),
  );
  static TextStyle heading2_6(BuildContext context) {
    return GoogleFonts.quicksand(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.primary),
    );
  }

  static TextStyle heading3 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      //used
      //Today’s Overview
      //Clock In/out
    ),
  );
  static TextStyle heading3_1 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle heading3_2 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFCBCBCD)),
  );
  static TextStyle heading3_3 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textLight2),
  );
  static TextStyle heading3_4(BuildContext context) {
    return GoogleFonts.quicksand(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.primary),
    );
  }

  static TextStyle heading3_5 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFCBCBCD)),
  );
  static TextStyle heading3_6(BuildContext context) {
    return GoogleFonts.quicksand(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primaryContainer),
    );
  }

  static TextStyle heading3_7 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor1),
  );
  static TextStyle heading3_8 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textdanger),
  );
  // static TextStyle heading3_8 = GoogleFonts.quicksand(
  //   textStyle: const TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFED4822)),
  // );

  static TextStyle heading4 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF969696)),
  );

  static TextStyle displayText = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor1,
    ),
  );
  static TextStyle displayText_2 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle displayText_3(BuildContext context) {
    return GoogleFonts.quicksand(
      textStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary),
    );
  }

  static TextStyle headingStyle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
  );

  // static TextStyle boldLabel = GoogleFonts.quicksand(
  //   textStyle: const TextStyle(
  //     fontSize: 14,
  //     fontWeight: FontWeight.w600,
  //     color: AppColors.textColor1,
  //   ),
  // );

  // static TextStyle smallLabel = GoogleFonts.quicksand(
  //   textStyle: const TextStyle(
  //     fontSize: 12,
  //     fontWeight: FontWeight.w400,
  //     // color: AppColors.textColor1,
  //   ),
  // );
  static TextStyle smalBoldlLabel = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor1,
    ),
  );
  static TextStyle smalBoldlLabel_2 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryColor,
    ),
  );
  static TextStyle smalBoldlLabel_3 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textLight2),
  );
  static TextStyle smalBoldlLabel_4 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLight2),
  );

  // static TextStyle smalBoldlLabel_2(BuildContext context) {
  //   return GoogleFonts.quicksand(
  //     textStyle: TextStyle(
  //       fontSize: 12,
  //       fontWeight: FontWeight.w600,
  //       color: Theme.of(context).colorScheme.primary,
  //     ),
  //   );
  // }

  // static TextStyle smallLabel_1 = GoogleFonts.quicksand(
  //   textStyle: const TextStyle(
  //     fontSize: 11,
  //     fontWeight: FontWeight.w400,
  //     color: Colors.white,
  //   ),
  // );

  // static TextStyle inputField = GoogleFonts.quicksand(
  //   textStyle: const TextStyle(
  //     fontSize: 14,
  //     fontWeight: FontWeight.w400,
  //     // color: AppColors.textColor1,
  //   ),
  // );
}
