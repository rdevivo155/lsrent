import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyStatefulWidget(),backgroundColor: Color(0xff569CDD))
    ;
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

                )),
            Container(
              padding: const EdgeInsets.fromLTRB(20,300,20,20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_rounded ,color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(fontFamily: 'Montserrat',fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock ,color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontFamily: 'Montserrat',fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ElevatedButton(
                  child: const Text('ACCEDI',
                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xfff4af49)

                  ),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                    Navigator.of(context).popAndPushNamed('/home');
                  },
                )
            ),
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: ElevatedButton(
                  child: const Text('REGISTRATI',
                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff569CDD),
                      side: BorderSide(width: 1.0, color: Colors.white)
                  ),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )
            ),
            Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextButton(
                  child: const Text(
                    'Password dimenticata',
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
            )
          ],
        ));
  }
}
