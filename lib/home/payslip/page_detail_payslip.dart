import 'package:flutter/material.dart';
import '/components/primary_button.dart';
import '/components/secondary_container.dart';
import '/components/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class PageDetailPayslip extends StatelessWidget {
  const PageDetailPayslip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            Text(
              'Payslip',
              style: AppTextStyles.heading1_1,
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              _buildPayslipDetail(context),
              const SizedBox(height: 10),
              PrimaryButton(
                buttonWidth: MediaQuery.of(context).size.width / 1.4,
                buttonText: 'Done',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayslipDetail(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/payslip_detail.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            _buildMonthRow(context),
            const SizedBox(height: 55),
            _buildSectionTitle('Earnings'),
            _buildEarnings(),
            _buildSummaryRow('Total earnings', '€3.201,00'),
            const Divider(color: Colors.grey),
            _buildSectionTitle('Deductions'),
            _buildDeductions(),
            _buildSummaryRow('Total deductions', '€195,00'),
            const Divider(color: Colors.grey),
            _buildSummaryRow('Net Salary', "€3.006,00"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 77,
              width: 77,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mike Cooper', style: AppTextStyles.heading1),
                Text('Marketing Officer', style: AppTextStyles.heading1),
                Text('DE3824-MO4', style: AppTextStyles.heading3_3),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            const url = 'https://jt-hcm.simise.id/web/content/4001';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            } else {
              // ignore: use_build_context_synchronously
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('Could not open the document.'),
              //   ),
              // );
            }
          },
          icon: const Icon(
            Icons.download_for_offline_outlined,
            size: 45,
            color: Colors.white60,
          ),
        )
      ],
    );
  }

  Widget _buildMonthRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('DEC', style: AppTextStyles.heading1),
        SecondaryContainer(
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: Text('September 2023', style: AppTextStyles.heading1_1),
          ),
        ),
      ],
    );
  }

  Widget _buildEarnings() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Basic salary', '€2.500,00'),
          _buildSummaryRow('Overtime pay', '€540,00'),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('12 hours x €45', style: AppTextStyles.heading3_3),
          ),
          _buildSummaryRow('Bonuses', '€100,00'),
          _buildSummaryRow('Reimbursements', '€61,00'),
        ],
      ),
    );
  }

  Widget _buildDeductions() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          _buildSummaryRow('Income tax', '€30,00'),
          _buildSummaryRow('Health Insurance', '€45,00'),
          _buildSummaryRow('Retirement Contributions', '€35,00'),
          _buildSummaryRow('Loan Repayments', '€75,00'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading1);
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.heading1),
          Text(value, style: AppTextStyles.heading1),
        ],
      ),
    );
  }
}
