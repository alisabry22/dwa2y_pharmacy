import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:flutter/material.dart';

class CustomDashboardContainer extends StatelessWidget {
  const CustomDashboardContainer({super.key,required this.icon,required this.text,required this.totalnumber});
final Icon icon;
final String text;
final String totalnumber;
  @override
  Widget build(BuildContext context) {
    return  Container(
      width:MediaQuery.of(context).size.width*0.3,
      height: 80,
      decoration: BoxDecoration(
             color: Colors.white,
             boxShadow: [BoxShadow(color:Color(0xff4062BB),blurRadius: 5,spreadRadius: 0.5)],
             borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
          
            Text(text,style: TextStyle(fontSize: 10,color: Constants.textColor),),
            Text(totalnumber, style:TextStyle(fontSize: 10,color: Constants.textColor)),
          ],
        ),
      
    );
  }
}