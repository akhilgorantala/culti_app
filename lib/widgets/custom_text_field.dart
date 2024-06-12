import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30)),
          child: TextField(
            controller: controller,
            cursorColor: Color(0xff37B44B),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ));
  }
}
