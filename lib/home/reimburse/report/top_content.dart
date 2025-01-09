// import 'package:flutter/material.dart';

// import '../../../components/primary_container.dart';
// import '../../../components/text_style.dart';

// class TopContent extends StatefulWidget {
//   const TopContent({super.key});

//   @override
//   State<TopContent> createState() => TopContentState();
// }

// class TopContentState extends State<TopContent> {
//   final TextEditingController _controller = TextEditingController();
//   final int maxLength = 2000;
//   String get description => _controller.text;
//   @override
//   Widget build(BuildContext context) {
//     return PrimaryContainer(
//       borderRadius: BorderRadius.circular(0),
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Report Summary',
//               style: AppTextStyles.heading2_1,
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _controller,
//               maxLines: 1,
//               maxLength: maxLength,
//               buildCounter: (_,
//                   {int? currentLength, bool? isFocused, int? maxLength}) {
//                 // Menghilangkan penghitung bawaan
//                 return null;
//               },
//               style: AppTextStyles.heading2_4,
//               decoration: InputDecoration(
//                 hintText: 'write your report summary here...',
//                 hintStyle: AppTextStyles.heading2,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'maximum $maxLength character',
//                   style: AppTextStyles.heading4,
//                 ),
//                 Text(
//                   '${_controller.text.length}/$maxLength',
//                   style: AppTextStyles.heading4,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
