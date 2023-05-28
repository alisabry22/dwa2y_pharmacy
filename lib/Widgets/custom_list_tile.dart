import 'package:flutter/material.dart';

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
    this.trailing=  const Icon(Icons.arrow_forward,color: Constants.textColor,),
    this.subtitile="",


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      minLeadingWidth: 10,
      onTap:onTap,
      leading:leading,
       subtitle: Text(subtitile,style:const TextStyle(fontSize: 12,color: Colors.grey)),
      title:Text(title,style: const TextStyle( fontSize: 14, color: Constants.textColor,fontWeight: FontWeight.w500), ),
      trailing: trailing,
    );
  }
}