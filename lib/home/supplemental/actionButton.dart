import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
          bottom: 11,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 91,
              child: Image.asset(imagePath),
            ),
            Text(
              label,
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
    );
  }
}