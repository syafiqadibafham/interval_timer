import 'package:flutter/material.dart';

class customElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;

  final Color backgroundColor;
  final Color forgroundColor;

  String label;
  IconData? iconLabel;

  double height;
  double width;

  customElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.backgroundColor,
      required this.forgroundColor,
      required this.label,
      this.iconLabel})
      : height = 70,
        width = 130,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconLabel == null
                ? Container()
                : Icon(iconLabel, color: forgroundColor),
            Text(
              label,
              style: TextStyle(color: forgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
