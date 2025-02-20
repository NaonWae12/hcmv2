// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/primary_button.dart';
import '../../components/text_style.dart';

import 'approval/page_approval.dart';
import 'date.dart';

import 'expense_submission.dart';
import 'history_reimburse/page_history.dart';

import 'midle_content.dart';
// import 'reimburse_list.dart';
import 'top_content.dart';
import 'total_amount.dart';

class PageReimburse extends StatefulWidget {
  const PageReimburse({super.key});

  @override
  State<PageReimburse> createState() => _PageReimburseState();
}

class _PageReimburseState extends State<PageReimburse> {
  final GlobalKey<TopContentState> _topContentKey = GlobalKey();
  final GlobalKey<MidleContentState> _midleContentKey = GlobalKey();
  final GlobalKey<TotalAmountState> _totalAmountKey = GlobalKey();
  final GlobalKey<DateState> _dateKey = GlobalKey();
  // final GlobalKey<ReimburseListState> _reimburseListKey = GlobalKey();

  int? employeeId;
  String? roleUser;
  int tabCount = 2;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    _loadRoleUser();
  }

  Future<void> _loadEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id');
    });
  }

  Future<void> _loadRoleUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      roleUser = prefs.getString('role_user');
      print('Role User: $roleUser');
      tabCount = (roleUser == 'approver') ? 3 : 2;
    });
  }

  void _handleAddExpense() {
    ExpenseSubmission(context).addExpenseAndSubmit(
      description: _topContentKey.currentState?.description ?? '',
      productId: _midleContentKey.currentState?.selectedExpenseCategoryId ?? 0,
      totalAmount: int.tryParse(
            _totalAmountKey.currentState?.formattedAmount
                    .replaceAll(RegExp(r'[^0-9]'), '') ??
                '0',
          ) ??
          0,
      date: _dateKey.currentState?.selectedDate
              ?.toIso8601String()
              .split('T')[0] ??
          '',
      onSuccess: () {
        // Reset komponen setelah pengiriman berhasil
        _topContentKey.currentState?.resetDescription();

        _totalAmountKey.currentState?.resetData();

        _dateKey.currentState?.resetSelectedDate();

        setState(() {}); // Segarkan halaman
      },
    );
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
                'Reimbursement',
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
            SingleChildScrollView(
              child: Column(
                children: [
                  TopContent(key: _topContentKey),
                  const SizedBox(height: 10),
                  MidleContent(key: _midleContentKey),
                  const SizedBox(height: 10),
                  TotalAmount(key: _totalAmountKey),
                  const SizedBox(height: 10),
                  Date(key: _dateKey),
                  const SizedBox(height: 10),
                  // ReimburseList(key: _reimburseListKey),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PrimaryButton(
                      buttonHeight: 50,
                      buttonWidth: MediaQuery.of(context).size.width,
                      buttonText: 'Add Expense',
                      onPressed: _handleAddExpense,
                    ),
                  ),
                ],
              ),
            ),
            const PageHistory(),
            if (roleUser == 'approver') const PageApproval(),
          ],
        ),
      ),
    );
  }
}
