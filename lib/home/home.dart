import 'package:flutter/material.dart';
import '../../components/button.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyStatefulWidget(), backgroundColor: Colors.white);
  }
}

List<Card> _buildGridCards(BuildContext context) {
  List<Button> buttons = [];
  buttons[0] = Button(name: 'Sinistro', icon: 'sinistro');
  buttons[1] = Button(name: 'Pagamenti', icon: 'Pagamenti');
  buttons[2] = Button(name: 'Guasto', icon: 'guasto');
  buttons[3] = Button(name: 'Permessi', icon: 'permessi');

  if (buttons.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);

  return buttons.map((button) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // TODO: Adjust card heights (103)
      elevation: 0.0,
      child: Column(
        // TODO: Center items on the card (103)
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.asset(
              'assets/shipping.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                // TODO: Align labels to the bottom and center (103)
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                // TODO: Change innermost Column (103)
                children: <Widget>[
// TODO: Handle overflowing labels (103)
                  Text(
                    button.name,
                    style: theme.textTheme.button,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  // End new code
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isStartedAttendance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/login');
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.account_circle,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: ListView(children: <Widget>[
          const SizedBox(height: 20.0),
          Column(children: <Widget>[
            const SizedBox(height: 8.0),
            Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          flex: 50,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(children: <Widget>[
                              const Text(
                                "Prossimo turno",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Image.asset('assets/shipping.png')
                            ]),
                          )),
                      Flexible(
                          flex: 50,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(children: const <Widget>[
                              SizedBox(height: 40.0),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "DACIA",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "DOCKER",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "FC123DV",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                            ]),
                          )),
                    ],
                  ))
            ]),
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Flexible(
                        flex: 50,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(children: <Widget>[
                            Row(children: [
                              Flexible(
                                  flex: 50,
                                  child: Container(
                                      child: Column(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "INIZIO",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ))
                                  ]))),
                              Flexible(
                                  flex: 50,
                                  child: Container(
                                      child: Column(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "09:00",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ))
                                  ])))
                            ]),
                            Row(children: [
                              Flexible(
                                  flex: 50,
                                  child: Container(
                                      child: Column(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "FINE",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ))
                                  ]))),
                              Flexible(
                                  flex: 50,
                                  child: Container(
                                      child: Column(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "18:00",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ))
                                  ])))
                            ]),
                          ]),
                        ),
                      ),
                      Flexible(
                        flex: 50,
                        child: GestureDetector(
                          onTap: () => setState(() {
                            isStartedAttendance = !isStartedAttendance;
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(children: <Widget>[
                              Container(
                                width: 82,
                                height: 77,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 82,
                                      height: 77,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                        color: !isStartedAttendance
                                            ? Color(0xff44b930)
                                            : Colors.red,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 63,
                                          height: 18,
                                          child: Text(
                                            !isStartedAttendance
                                                ? "INIZIO"
                                                : "FINE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      )
                    ]))
              ],
            ),
            const SizedBox(height: 40.0),
            Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Color(0x4d7BCEFD),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      )),
                  margin:
                      const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0),
                  child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16.0),
                      childAspectRatio: 8.0 / 9.0,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/accident');
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x3ff4af49),
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 25,
                                      right: 29,
                                      top: 11,
                                      bottom: 21,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 96,
                                          child: Image.asset(
                                              'assets/crashedCar.png'),
                                        ),
                                        Text(
                                          "Sinistro",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          width: 150,
                          height: 150,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3ff4af49),
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 26,
                                  right: 23,
                                  top: 5,
                                  bottom: 26,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 96,
                                      height: 96,
                                      child: Image.asset('assets/wallet.png'),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      "Pagamenti",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3ff4af49),
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 30,
                                  top: 11,
                                  bottom: 21,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset('assets/damage.png'),
                                    ),
                                    SizedBox(
                                      width: 71,
                                      child: Text(
                                        "Guasto",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/day-off');
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x3ff4af49),
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 13,
                                      right: 11,
                                      top: 13,
                                      bottom: 21,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 96,
                                          child:
                                              Image.asset('assets/dayOff.png'),
                                        ),
                                        SizedBox(
                                          width: 126,
                                          child: Text(
                                            "Permessi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ]),
                )),
          ])
        ])));
  }
}
