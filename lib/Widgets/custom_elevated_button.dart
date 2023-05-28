import 'package:flutter/material.dart';


import '../Utils/Constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
    final double width;
  final double height;
  final void Function() onPressed;
  final String text;
  const CustomElevatedButton({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.text,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width * 0.9, height * 0.13),
          backgroundColor: Constants.btnColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              
        ),
        onPressed:onPressed,

        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ));
  }
}