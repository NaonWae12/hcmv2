// import 'package:flutter/material.dart';
// import 'package:hcm/components/primary_button.dart';
// import 'package:hcm/components/primary_container.dart';
// import 'package:hcm/components/text_style.dart';

// class PageAttendanceDone extends StatelessWidget {
//   const PageAttendanceDone({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/bg.png'), fit: BoxFit.fill)),
//           ),
//           Column(
//             children: [
//               const SizedBox(height: 8),
//               Align(
//                   alignment: Alignment.centerLeft,
//                   child: IconButton(
//                       onPressed: () {}, icon: const Icon(Icons.arrow_back))),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/image_done.png',
//                       height: 100,
//                       width: 100,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       '07.58 AM',
//                       style: AppTextStyles.displayText,
//                     ),
//                     Text(
//                       "You’re checked in!",
//                       style: AppTextStyles.displayText_2,
//                     ),
//                     const SizedBox(height: 10),
//                     PrimaryContainer(
//                       width: MediaQuery.of(context).size.width / 1.1,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   height: 77,
//                                   width: 77,
//                                   decoration: BoxDecoration(
//                                       color: Colors.amber,
//                                       borderRadius: BorderRadius.circular(10)),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Mike Cooper',
//                                       style: AppTextStyles.heading1_1,
//                                     ),
//                                     Text(
//                                       'Marketing Officer',
//                                       style: AppTextStyles.heading1,
//                                     ),
//                                     Text(
//                                       'DE3824-MO4',
//                                       style: AppTextStyles.heading3_3,
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Image.asset(
//                               'assets/green_done.png',
//                               height: 37,
//                               width: 37,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 1.1,
//                       child: Text(
//                         'Great job! Your attendance has been successfully logged. Hope you have a great day!',
//                         style: AppTextStyles.heading2,
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.clip,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               PrimaryButton(
//                 buttonHeight: 48,
//                 buttonWidth: MediaQuery.of(context).size.width / 1.4,
//                 buttonText: 'Back to Home',
//                 onPressed: () {},
//               ),
//               const SizedBox(height: 20)
//             ],
//           ),
//         ],
//       ),
//     ));
//   }
// }
