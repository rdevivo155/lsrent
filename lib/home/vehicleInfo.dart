// import 'package:flutter/material.dart';
// import '../model/response/shift_of_the_day_response.dart';


// // Widget per mostrare le informazioni del veicolo
// class VehicleInfoWidget extends StatelessWidget {
//   final BuildContext context;
//   final ShiftOfTheDayResponse? shiftOfTheDayResponse;

//   VehicleInfoWidget({required this.context, this.shiftOfTheDayResponse});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Flexible(
//                 flex: 50,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.asset('assets/shipping.png'),
//                     )
//                   ]),
//                 )),
//             Flexible(
//                 flex: 50,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   child: Column(children: <Widget>[
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           shiftOfTheDayResponse?.data?.vehicleModel?.brand ?? "",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontFamily: "Montserrat",
//                             fontWeight: FontWeight.w700,
//                           ),
//                           textAlign: TextAlign.left,
//                         )),
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           shiftOfTheDayResponse?.data?.vehicleModel?.description ?? "",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontFamily: "Montserrat",
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textAlign: TextAlign.left,
//                         )),
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           shiftOfTheDayResponse?.data?.vehicleModel?.carPlate ?? "",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontFamily: "Montserrat",
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textAlign: TextAlign.left,
//                         )),
//                   ]),
//                 )),
//           ],
//         ));
//   }
// }