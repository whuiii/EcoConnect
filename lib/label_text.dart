import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Text(text,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }
}
