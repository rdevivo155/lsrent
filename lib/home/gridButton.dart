import 'package:flutter/material.dart';
import 'package:ls_rent/home/supplemental/customCard.dart';

class GridButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: MediaQuery.of(context).size.height * 0.1, // Altezza minima come percentuale dell'altezza dello schermo
            ),
            decoration: BoxDecoration(
              color: Color(0x4d7BCEFD),
            ),
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomCard(
                    title: "Sinistro",
                    routeName: '/accident',
                    imagePath: 'assets/crashedCar.png',
                  ),
                ),
                Expanded(
                  child: CustomCard(
                    title: "Guasto",
                    routeName: '/broken-down',
                    imagePath: 'assets/damage.png',
                  ),
                ),
              ],
          ),
        );
  }
}

// class GridButtonsWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: double.infinity,
//         minHeight: 0.5,
//       ),
//       decoration: new BoxDecoration(
//         color: Color(0x4d7BCEFD),
//       ),
//       margin: const EdgeInsets.only(
//         left: 0.0,
//         right: 0.0,
//         bottom: 0.0,
//         top: 0,
//       ),
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: GridView.count(
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(12.0),
//         childAspectRatio: 20.0 / 15.0,
//         children: [
//           CustomCard(title: "Sinistro", routeName: '/accident', imagePath: 'assets/crashedCar.png'),
//           // InkWell(
//           //   onTap: () {
//           //     Navigator.of(context).pushNamed('/accident');
//           //   },
//           //   child: Container(
//           //     width: 150,
//           //     height: 150,
//           //     child: Row(
//           //       mainAxisSize: MainAxisSize.min,
//           //       mainAxisAlignment: MainAxisAlignment.center,
//           //       crossAxisAlignment: CrossAxisAlignment.center,
//           //       children: [
//           //         Container(
//           //           width: 150,
//           //           height: 150,
//           //           decoration: BoxDecoration(
//           //             borderRadius: BorderRadius.circular(15),
//           //             boxShadow: [
//           //               BoxShadow(
//           //                 color: Color(0x3ff4af49),
//           //                 blurRadius: 4,
//           //                 offset: Offset(0, 3),
//           //               ),
//           //             ],
//           //             color: Colors.white,
//           //           ),
//           //           padding: const EdgeInsets.only(
//           //             left: 25,
//           //             right: 29,
//           //             top: 11,
//           //             bottom: 11,
//           //           ),
//           //           child: Column(
//           //             mainAxisSize: MainAxisSize.min,
//           //             mainAxisAlignment: MainAxisAlignment.end,
//           //             crossAxisAlignment: CrossAxisAlignment.center,
//           //             children: [
//           //               Container(
//           //                 width: 96,
//           //                 height: 91,
//           //                 child: Image.asset('assets/crashedCar.png'),
//           //               ),
//           //               Text(
//           //                 "Sinistro",
//           //                 textAlign: TextAlign.center,
//           //                 style: TextStyle(
//           //                   color: Colors.black,
//           //                   fontSize: 14,
//           //                   fontFamily: "Montserrat",
//           //                   fontWeight: FontWeight.w600,
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           InkWell(
//             onTap: () {
//               Navigator.of(context).pushNamed('/broken-down');
//             },
//             child: Container(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0x3ff4af49),
//                           blurRadius: 4,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                       color: Colors.white,
//                     ),
//                     padding: const EdgeInsets.only(
//                       left: 24,
//                       right: 30,
//                       top: 11,
//                       bottom: 11,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 96,
//                           height: 91,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Image.asset('assets/damage.png'),
//                         ),
//                         SizedBox(
//                           width: 71,
//                           child: Text(
//                             "Guasto",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontFamily: "Montserrat",
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }