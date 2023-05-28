import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chat_controller.dart';
import '../../Models/chatmodel.dart';
import '../../Utils/Constants/constants.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key, required this.customer,required this.chatid});
  final UserModel customer;
  final String chatid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.username!,
              style: TextStyle(color: Constants.textColor, fontSize: 16),
            ),
            Text(
              "online",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.getChatMessages(chatid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                 
                    
                      return ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                          
                            ChatMessage message = ChatMessage.fromJson(
                                snapshot.data!.docs[index].data());
                                
                                  return Column(
                                    children: [
                                      BubbleNormal(
                              text: message.message,
                              color: message.sender ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Color(0xff4062BB)
                                      : Colors.grey,
                              isSender: message.sender ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? false
                                      : true,
                                      tail: true,
                                      textStyle:TextStyle(color:message.sender ==
                                          FirebaseAuth.instance.currentUser!.uid?Colors.white:Colors.black ) ,
                                      
                            ),
                            Text(message.sentat.toString().substring(11,16)),
                                    ],
                                  );
                                
                             
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: snapshot.data!.docs.length+1);
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Start Your Chat With Him now",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Start Your Chat With Him now",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                }),
          ),
          MessageBar(
            onSend: (value) async {
              ChatMessage message = ChatMessage(
                  sender: FirebaseAuth.instance.currentUser!.uid,
                  receiver: customer.userid!,
                  message: value,
                  sentat: DateTime.now());
              await controller.sendMessage(message,chatid );
            },
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
