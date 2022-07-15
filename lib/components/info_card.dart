import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String? text;
  final IconData? icon;
  Function? onPressed;

  InfoCard(
      {@required this.text, @required this.icon, @required this.onPressed});

  emptyfunction() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? emptyfunction(),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Color(0xff569CDD),
          ),
          title: Text(
            text ?? "",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: "Source Sans Pro"),
          ),
        ),
      ),
    );
  }
}
