import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {super.key,
      required this.isSender,
      required this.message,
      required this.sentat,
      required this.delivered,
      required this.seen,
      
      this.textStyle = const TextStyle(color: Colors.white, fontSize: 14),
      this.color=Colors.white70,
      
      });
  final bool isSender;
  final TextStyle textStyle;
  final String message;
  final String sentat;
  final Color color;
  final bool delivered;
  final bool seen;

  @override
  Widget build(BuildContext context) {
       Icon? icon;
   if(isSender&&delivered){
      icon=Icon(Icons.done_all,color: Colors.grey,size: 16,);
    }
    if(isSender&&seen){
      icon=Icon(Icons.done_all,color: Colors.green,size: 16,);
    }
    if(isSender && !delivered && !seen){
       icon=Icon(Icons.done,color: Colors.grey,size: 16,);
    }  
    return Row(
      
      children:[
          isSender
            ?Container():Expanded(
                child: SizedBox(
                  width: 5,
                ),
              ),
        Container(
          color: Colors.transparent,
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5,minWidth: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isSender ? Radius.circular(14) : Radius.circular(0),
                topRight: isSender ? Radius.circular(0) : Radius.circular(14),
                bottomLeft:Radius.circular(12) ,
                bottomRight: Radius.circular(12),
              ),
              color: color,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: textStyle,
                    textAlign: TextAlign.left,
                  ),
               
                      
                      
                      Row(
                        children: [
                          icon!=null?  icon:Container(),
                          SizedBox(width: 5,),
                          Text(sentat,style: TextStyle(color:isSender?Colors.white: Colors.black,fontSize: 11),),
                        ],
                      ),
                    
                 
                ],
              ),
            ),
          ),
        ),
      ),
      ] 
    );
  }
}
