import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainerHome extends StatelessWidget {
  const CustomContainerHome({super.key, 

    required this.onTap,
    required this.title,
     required this.backgroundImage,
  });
final void Function()? onTap;
final String title;
  final  ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow:const  [
          BoxShadow(
            blurRadius: 10,
            blurStyle: BlurStyle.outer,
            color: Colors.grey,
            spreadRadius: 0.3
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      color:const  Color(0xffEEEEEE),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

             Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:DecorationImage(image: backgroundImage!,fit: BoxFit.cover),
              ),
              
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              title,
              style:
                  GoogleFonts.poppins(color:const Color(0xff182747), fontSize: 16,fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}