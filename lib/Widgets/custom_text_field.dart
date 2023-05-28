
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {

final String hintText;
String? Function(String?)? validator;
TextEditingController controller;
Widget? suffixIcon;
Widget? prefixIcon;
bool obscureValue;
Function(String)? onchanged;
TextInputType? keyboardType;

  CustomTextField({
    Key? key,
    required this.hintText,
    required this.validator,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureValue=false,
    this.onchanged,
    this.keyboardType,
  }) : super(key: key);
   

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller ,
      onChanged:onchanged ,
      validator:validator ,
      obscureText: obscureValue,
      cursorColor: Colors.grey,
        keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon:suffixIcon ,
        hintText: hintText,
        prefixIcon: prefixIcon,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder:const  UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder:const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
       
        fillColor: Colors.white,
        filled: true,
        
      ),
    );
  }
}
