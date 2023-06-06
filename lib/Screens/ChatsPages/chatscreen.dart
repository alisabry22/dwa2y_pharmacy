import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chat_controller.dart';
import '../../Models/chatmodel.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.customer, required this.chatid});
  final UserModel customer;
  final String chatid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.find<ChatController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updateseenMessages(widget.chatid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.username!,
              style: TextStyle(color: Constants.textColor, fontSize: 16),
            ),
            Obx(
              () => Text(
                controller.currentChatCustomer.value.status != null
                    ? controller.currentChatCustomer.value.status == "online"
                        ? "online"
                        : ""
                    : "",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.getChatMessages(widget.chatid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      controller
                          .getCustomerStatusDetails(widget.customer.userid!);

                      return ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            ChatMessage message = ChatMessage.fromJson(
                                snapshot.data!.docs[index].data());
                            if (message.seen != true &&
                                message.receiver ==
                                    FirebaseAuth.instance.currentUser!.uid) {
                              controller.updateMessageStatus(widget.chatid, snapshot.data!.docs[index].id);
                            }
                            if (message.messagetype == "text") {
                              return ChatBubble(
                                delivered: message.delivered != null
                                    ? message.delivered!
                                    : false,
                                seen: message.seen != null
                                    ? message.seen!
                                    : false,
                                isSender: message.sender ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? true
                                    : false,
                                color: message.sender ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Color(0xff4062BB)
                                    : Colors.grey.shade300,
                                message: message.message,
                                textStyle: TextStyle(
                                    color: message.sender ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? Colors.white
                                        : Colors.black),
                                sentat: int.parse(message.sentat
                                            .toString()
                                            .substring(11, 13)) >=
                                        12
                                    ?  "${int.parse(message.sentat.toString().substring(11, 13)) - 12}:${message.sentat.toString().substring(14, 16)}${"PM".tr}"
                                    : "${message.sentat.toString().substring(11, 16)}${"AM".tr}",
                              );
                            } else {
                              
                              return BubbleNormalImage(
                                delivered: message.receiver==FirebaseAuth.instance.currentUser!.uid ?false:message.delivered!=null?message.delivered!:false,
                                isSender:message.sender==FirebaseAuth.instance.currentUser!.uid?false:true,
                                sent: message.receiver==FirebaseAuth.instance.currentUser!.uid?false:true,
                                seen: message.receiver==FirebaseAuth.instance.currentUser!.uid?false:message.seen!,
                                tail: true,
                                
                                  id: message.sentat.toString(),
                                  image: CachedNetworkImage(
                                      imageUrl: message.pictureMessage!));
                            }
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: snapshot.data!.docs.length);
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Start Your Chat With Him now".tr,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Start Your Chat With Him now".tr,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                }),
          ),
          MessageBar(
            onSend: (value) async {
              bool delivered = false;
              if (controller.currentChatCustomer.value.status != null &&
                  controller.currentChatCustomer.value.status == "online") {
                delivered = true;
              }
              ChatMessage message = ChatMessage(
                  messagetype: "text",
                  sender: FirebaseAuth.instance.currentUser!.uid,
                  receiver: widget.customer.userid!,
                  message: value,
                  delivered: delivered,
                  sentat: DateTime.now());
              await controller.sendMessage(message, widget.chatid);
              controller.sendNotificationMessage(widget.chatid,widget.customer.token!, message);
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
                  onTap: () {
                        Get.bottomSheet(
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.white,
                                                height: MediaQuery.of(context).size.height*0.15,
                                                child: Column(
                                                  children: [
                                                     Text("Add Photo".tr),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: ()async{
                                                            await controller.ImagePickerFromCamera(widget.chatid,widget.customer);
                                                          },
                                                          child: Column(
                                                            children:  [
                                                             Container(width: 40,height: 40,decoration:  BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: Colors.grey,
                                                                  )
                                                                ),child: const Icon(Icons.image,color: Constants.textColor,)),
                                                                const SizedBox(height: 10,),
                                                               Text("Camera".tr),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: ()async{
                                                             await controller.ImagePickerFromGallery(widget.chatid,widget.customer);
                                                          },
                                                          child: Column(
                                                            children:  [
                                                                Container(width: 40,height: 40,decoration:  BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: Colors.grey,
                                                                  )
                                                                ),child: const Icon(Icons.image,color: Constants.textColor,)),
                                                                const SizedBox(height: 10,),
                                                               Text("Gallery".tr),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
