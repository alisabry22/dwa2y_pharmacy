import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUpdateFieldBottomSheet extends StatelessWidget {
 const  CustomUpdateFieldBottomSheet(
      {super.key, required this.controller, required this.onPressed,required this.hintText,required this.title,this.textInputType});
  final TextEditingController controller;
  final String title;
  final void Function() onPressed;
  final String hintText;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 10)
        ]),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
               Text(title,style: GoogleFonts.poppins(color: Constants.textColor,fontWeight: FontWeight.w500),),
              CustomTextField(
                keyboardType: textInputType,
                  hintText: hintText,
                  validator: (p0) {return p0;},
                  controller: controller),
              CustomElevatedButton(
                  width: 120, height: 50, onPressed: onPressed, text: "Update"),
            ])));
  }
}
