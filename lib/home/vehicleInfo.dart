import 'package:flutter/material.dart';
import 'package:ls_rent/model/response/vehicle_model_response.dart';
import 'package:ls_rent/model/response/vehicle_response.dart';

class VehicleInfoWidget extends StatelessWidget {
  final VehicleModelResponse? vehicleModelResponse;
  final VehicleResponse? vehicleResponse;
  final String addressVehicle;

  VehicleInfoWidget(
      {required this.vehicleModelResponse,
      required this.vehicleResponse,
      required this.addressVehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/shipping.png'),
                    )
                  ]),
                ),
              ),
              Flexible(
                flex: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        vehicleModelResponse?.data?.brand ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        vehicleModelResponse?.data?.description ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        vehicleResponse?.data?.carPlate ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(addressVehicle, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}