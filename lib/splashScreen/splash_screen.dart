import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ls_rent/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=> Navigator.of(context).popAndPushNamed('/login')
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: baseBackgroundColor,
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
      width: 210,
      child: Column(
        children: [
        Image.asset('assets/logoApp.png',width: 150,height: 150,),


        ],

      ),
    )
      ],
    )));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
