// import 'package:flutter/material.dart';
// import 'package:hcm/components/text_style.dart';

// class TimeSelector extends StatefulWidget {
//   const TimeSelector({super.key});

//   @override
//   State<TimeSelector> createState() => _TimeSelectorState();
// }

// class _TimeSelectorState extends State<TimeSelector> {
//   TimeOfDay? _startTime = const TimeOfDay(hour: 12, minute: 0);
//   TimeOfDay? _endTime = const TimeOfDay(hour: 13, minute: 0);

//   Future<void> _selectTime(BuildContext context, bool isStart) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: isStart ? _startTime! : _endTime!,
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startTime = picked;
//         } else {
//           _endTime = picked;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildTimeField(context, 'Start Time', _startTime!, true),
//         _buildTimeField(context, 'End Time', _endTime!, false),
//       ],
//     );
//   }

//   Widget _buildTimeField(
//       BuildContext context, String label, TimeOfDay time, bool isStart) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: AppTextStyles.heading2_1),
//         GestureDetector(
//           onTap: () => _selectTime(context, isStart),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             width: MediaQuery.of(context).size.width * 0.44,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   time.format(context),
//                   style: AppTextStyles.heading2_4,
//                 ),
//                 const Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
