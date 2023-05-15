import 'package:flutter/material.dart';


class CustomAddressField extends StatelessWidget {
  const CustomAddressField({super.key,required this.controller, required this.hintText,this.keyboardType});
 final TextEditingController controller;
 final String hintText;
 final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                      validator: (value) {
                        if(value==null || value.isEmpty){
                          return 'this field is required';
                        }else{
                          return null;
                        }
                      },
                      controller: controller,
                      cursorColor: Colors.grey,
                      keyboardType: keyboardType,
                      decoration:  InputDecoration(
                        hintText: hintText,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                        focusedBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                      ),
                    );
  }
}