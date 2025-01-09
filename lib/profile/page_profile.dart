import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/text_style.dart';
import 'about.dart';
import 'company.dart';
import 'general.dart';
import 'image_profile.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  String _jobId = 'Loading...';
  String _name = 'Loading...';

  @override
  void initState() {
    super.initState();

    _loadUserData(); // Load data saat widget diinisialisasi
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _jobId = prefs.getString('job_id') ?? 'Unknown Job';
      _name = prefs.getString('name') ?? 'Unknown Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    _name,
                    style: AppTextStyles.heading1_2,
                  ),
                  Text(
                    _jobId,
                    style: AppTextStyles.heading2,
                  ),
                  // Text(
                  //   'At Tricks. since 2021',
                  //   style: AppTextStyles.heading2,
                  // ),
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
      ),
    );
  }
}
