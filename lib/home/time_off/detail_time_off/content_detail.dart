import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/text_style.dart';

class ContentDetail extends StatefulWidget {
  const ContentDetail({super.key});

  @override
  State<ContentDetail> createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: SvgPicture.asset('assets/icons/time_off.svg')),
          ),
          Row(
            children: [
              Text(
                '25 Desember 2023',
                style: AppTextStyles.heading3_7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '|',
                  style: AppTextStyles.heading3_2,
                ),
              ),
              Text(
                '02 Januari 2024',
                style: AppTextStyles.heading3_8,
              ),
            ],
          ),
          Text(
            'duration_display',
            style: AppTextStyles.heading3_4(context),
          ),
          Text(
            'status : disetujui',
            style: AppTextStyles.heading3_4(context),
          ),
          Text(
            'private_name',
            style: AppTextStyles.heading3_4(context),
          )
        ],
      ),
    );
  }
}
