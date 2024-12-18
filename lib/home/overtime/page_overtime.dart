// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '/home/overtime/request/page_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/text_style.dart';
import 'approval/page_approval.dart';
import 'history/page_history.dart';

class PageOvertime extends StatefulWidget {
  const PageOvertime({super.key});

  @override
  State<PageOvertime> createState() => _PageOvertimeState();
}

class _PageOvertimeState extends State<PageOvertime> {
  String? roleUser;
  int tabCount = 2;
  @override
  void initState() {
    super.initState();

    _loadRoleUser();
  }

  Future<void> _loadRoleUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      roleUser = prefs.getString('role_user');
      print('Role User: $roleUser');
      tabCount = (roleUser == 'approver') ? 3 : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                'Overtime',
                style: AppTextStyles.heading1_1,
              ),
              const SizedBox(width: 40),
            ],
          ),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Request'),
              const Tab(text: 'History'),
              if (roleUser == 'approver') const Tab(text: 'Approval'),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: TabBarView(
          children: [
            const PageRequest(),
            const PageHistory(),
            if (roleUser == 'approver') const PageApproval(),
          ],
        ),
      ),
    );
  }
}
