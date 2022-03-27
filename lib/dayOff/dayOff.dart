import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class DayOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Permessi'),
        ),
        body: MyStatefulWidget(),backgroundColor: Colors.white)
    ;
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
    child: ListView(
    children: <Widget>[
    Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10),
    child: const Text(
    'LS RENT',
    style: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 30,color: Colors.white),

    )
    )]
    )
    );
  }
}