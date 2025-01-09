// import 'package:flutter/material.dart';
// import '/components/colors.dart';
// import '/components/primary_button.dart';
// import '/components/primary_container.dart';
// import '/components/text_style.dart';
// import 'expense_modal.dart';

// class BottomContent extends StatefulWidget {
//   final Function(List<dynamic>) onSelectedExpenses;

//   const BottomContent({super.key, required this.onSelectedExpenses});

//   @override
//   State<BottomContent> createState() => _BottomContentState();
// }

// class _BottomContentState extends State<BottomContent> {
//   List<dynamic> _selectedExpenses = [];

//   void _showExpenseModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return ExpenseModal(
//           onSelectedItems: (selectedItems) {
//             setState(() {
//               _selectedExpenses = selectedItems;
//               // Fungsi untuk Kirim data ke parent widget (PageCreateReport)
//               widget.onSelectedExpenses(
//                 _selectedExpenses.map((item) => item['id']).toList(),
//               );
//             });
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PrimaryContainer(
//       borderRadius: BorderRadius.circular(0),
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text('Expense', style: AppTextStyles.heading2_1),
//             const SizedBox(height: 10),
//             ..._selectedExpenses.map((expense) {
//               if (expense is Map<String, dynamic>) {
//                 return ListTile(
//                   title: Text(expense['name'] ?? 'No description'),
//                   subtitle: Text(expense['date'] ?? 'No date'),
//                   trailing: Text(
//                     'Rp. ${expense['total_amount_currency']}',
//                     style: AppTextStyles.smalBoldlLabel,
//                   ),
//                 );
//               } else {
//                 return const ListTile(
//                   title: Text('Invalid data'),
//                 );
//               }
//               // ignore: unnecessary_to_list_in_spreads
//             }).toList(),
//             const SizedBox(height: 10),
//             Center(
//               child: PrimaryButton(
//                 backgroundColor: AppColors.textdanger,
//                 buttonText: 'Add Expense',
//                 onPressed: () {
//                   _showExpenseModal(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
