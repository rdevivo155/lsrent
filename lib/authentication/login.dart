import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LoginViewModel.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Color(0xff569CDD),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: model.loading
                  ? Center(child: CircularProgressIndicator())
                  : LoginContent(model: model),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginContent extends StatelessWidget {
  final LoginViewModel model;

  const LoginContent({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        LogoSection(),
        EmailInputField(model: model),
        PasswordInputField(model: model),
        LoginButton(model: model),
        RegisterButton(),
        VersionText(),
      ],
    );
  }
}

class LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Image.asset(
          'assets/logo1.png',
          width: 150,
          height: 100,
        )
      )
    );
  }
}

class EmailInputField extends StatelessWidget {
  final LoginViewModel model;

  const EmailInputField({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextFormField(
        controller: model.nameController,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusColor: Colors.white,
          prefixIcon: Icon(Icons.account_circle_rounded, color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

class PasswordInputField extends StatelessWidget {
  final LoginViewModel model;

  const PasswordInputField({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: TextFormField(
        obscureText: model.obscureText,
        cursorColor: Colors.white,
        controller: model.passwordController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusColor: Colors.white,
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          suffixIcon: InkWell(
            onTap: model.toggleObscureText,
            child: Icon(
              model.obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final LoginViewModel model;

  const LoginButton({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ElevatedButton(
        child: Text('ACCEDI', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
        style: ElevatedButton.styleFrom(
          backgroundColor: model.validateFields() ? Color(0xfff4af49) : Colors.blueGrey,
        ),
        onPressed: model.validateFields() ? () => model.loginAuth(navigatorKey.currentContext!, (title, content) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  );
}) : null,
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: ElevatedButton(
        child: Text('REGISTRATI', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff569CDD),
          side: BorderSide(width: 1.0, color: Colors.white)
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/registration');
        },
      ),
    );
  }
}

class VersionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('v1.0.4', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w200)),
    );
  }
}