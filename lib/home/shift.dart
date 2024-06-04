import 'package:flutter/material.dart';

class ShiftWidget extends StatelessWidget {
  final AsyncSnapshot projectSnap;
  final bool isOffline;
  final dynamic shiftOfTheDayResponse;
  final Function(BuildContext) getTurno;
  final Function(BuildContext) emptyShift;

  ShiftWidget({
    required this.projectSnap,
    required this.isOffline,
    required this.shiftOfTheDayResponse,
    required this.getTurno,
    required this.emptyShift,
  });

  @override
  Widget build(BuildContext context) {
    if (projectSnap.data != null && !isOffline) {
      if (shiftOfTheDayResponse != null) {
       return getTurno(context);
      } else {
       return emptyShift(context);
      }
    } else if (projectSnap.data != null && isOffline) {
      return Center(
        child: Text(
          'Assenza di rete',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      if (shiftOfTheDayResponse?.data == null) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/shipping.png'),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Nessun turno caricato',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("Attendere il caricamento dei turni..."),
        );
      }
    }
  }
}