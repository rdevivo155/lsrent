import 'package:flutter/material.dart';
import 'package:ls_rent/constants/constants.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String? text;
  final IconData? icon;
  final Function? onPressed;

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
            color: baseBackgroundColor,
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
