import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/Constants/constants.dart';

class CustomListTile extends StatelessWidget {
 final String title;
 final void Function()? onTap;
 final Widget? leading;
 final Widget? trailing;
 final String subtitile;
 const  CustomListTile({
    Key? key,
    required this.title,
    required this.onTap,
     this.leading,
    this.trailing=  const Icon(Icons.arrow_forward),
    this.subtitile="",


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap:onTap,
      horizontalTitleGap: 0.0,
      leading:leading,
      title:Text(title,style: GoogleFonts.poppins( fontSize: 16, color: Constants.textColor,fontWeight: FontWeight.w400), ),
      trailing: trailing,
      subtitle: Text(subtitile,style: GoogleFonts.poppins(color:Constants.textColor,fontSize: 14),),
    );
  }
}