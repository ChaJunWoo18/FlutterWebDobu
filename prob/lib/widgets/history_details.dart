// import 'package:flutter/material.dart';
// import 'package:prob/widgets/hist_detail_option.dart';
// import 'package:prob/widgets/line_widget.dart';

// class HistoryDetails extends StatelessWidget {
//   const HistoryDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 65,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: const BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: Colors.black38,
//               ),
//             ),
//             color: Colors.black12,
//           ),
//           child: const Row(
//             children: [
//               Flexible(
//                 flex: 5,
//                 child: HistDetailOptionLeft(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: HistDetailOptionRight(),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("2024.04.14~2024.07.13"),
//             Icon(Icons.calendar_today_rounded)
//           ],
//         ),
//         const LineWidget(),
//         FutureBuilder(
//           future: hisList,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   var hist = snapshot.data![index];
//                   var prevHist = index > 0 ? snapshot.data![index - 1] : null;

//                   Widget monthWidget = (prevHist == null ||
//                           prevHist.date.substring(0, 7) !=
//                               hist.date.substring(0, 7))
//                       ? Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(hist.date.substring(0, 7)),
//                               const Icon(Icons.keyboard_arrow_up_rounded),
//                             ],
//                           ),
//                         )
//                       : const SizedBox(height: 0); //.shrink(); // 출력하지 않음
//                   return Container(
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         monthWidget,
//                         Text(hist.date),
//                         Text(hist.receiver),
//                         Text("${hist.amount}원"),
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: snapshot.data!.length,
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
