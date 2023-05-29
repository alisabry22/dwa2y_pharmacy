import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {super.key,
      required this.isSender,
      required this.message,
      required this.sentat,
      required this.delivered,
      required this.seen,
      this.icon=const Icon(Icons.done,size: 14,color: Colors.grey,),
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
   Icon icon;
  @override
  Widget build(BuildContext context) {
    if(delivered){
      icon=Icon(Icons.done_all,color: Color(0xFF97AD8E),size: 16,);
    }
    if(seen){
      icon=Icon(Icons.done_all,color: Colors.greenAccent,size: 16,);
    }
    return Row(
      
      children:[
          isSender
            ? Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5,minWidth: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isSender ? Radius.circular(0) : Radius.circular(14),
                topRight: isSender ? Radius.circular(14) : Radius.circular(0),
                bottomLeft:Radius.circular(14) ,
                bottomRight: Radius.circular(14),
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
                          icon,
                          SizedBox(width: 5,),
                          Text(sentat,style: TextStyle(color:isSender?Colors.black: Colors.white60,fontSize: 14),),
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
