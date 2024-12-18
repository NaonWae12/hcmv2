import 'package:flutter/material.dart';

import '../components/text_style.dart';
import 'about.dart';
import 'company.dart';
import 'general.dart';
import 'image_profile.dart';

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/appBar_bg_full.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageProfile(),
                Text(
                  'Mike Cooper',
                  style: AppTextStyles.heading1_2,
                ),
                Text(
                  'Marketing Officer • DE3824-MO4',
                  style: AppTextStyles.heading2,
                ),
                Text(
                  'At Tricks. since 2021',
                  style: AppTextStyles.heading2,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                style: AppTextStyles.heading3_3,
              ),
              General(),
              Text(
                'Company',
                style: AppTextStyles.heading3_3,
              ),
              Company(),
              Text(
                'About',
                style: AppTextStyles.heading3_3,
              ),
              About(),
            ],
          ),
        ),
      ),
    );
  }
}
