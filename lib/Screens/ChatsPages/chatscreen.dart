import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/chat_controller.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/chatmodel.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/chat_bubble.dart';
import '../../Widgets/message_bar.dart';
import '../../Widgets/voice_chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.customer, required this.chatid});
  final UserModel customer;

  final String chatid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.find<ChatController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.updateseenMessages(widget.chatid);
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
                chatController.currentChatCustomer.value.status != null
                    ? chatController.currentChatCustomer.value.status == "online"
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
                stream: chatController.getChatMessages(widget.chatid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      chatController
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
                              chatController.updateMessageStatus(
                                  widget.chatid, snapshot.data!.docs[index].id);
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
                                    ? "${int.parse(message.sentat.toString().substring(11, 13)) - 12}:${message.sentat.toString().substring(14, 16)}${"PM".tr}"
                                    : "${message.sentat.toString().substring(11, 16)}${"AM".tr}",
                              );
                            } else if (message.messagetype == "image") {
                              return BubbleNormalImage(
                                  delivered: message.receiver ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? false
                                      : message.delivered != null
                                          ? message.delivered!
                                          : false,
                                  isSender: message.sender ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? false
                                      : true,
                                  sent: message.receiver ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? false
                                      : true,
                                  seen: message.receiver ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? false
                                      : message.seen!,
                                  tail: true,
                                  id: message.sentat.toString(),
                                  image: CachedNetworkImage(
                                      imageUrl: message.pictureMessage!));
                            } else {
                              chatController.fetchAudio(
                                  message.voiceurl!,
                                  widget.chatid,
                                  message.voiceFileName!);
                              return VoiceBubble(
                                bubblecolor: message.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Color(0xff4062BB)
                                  : Colors.grey.shade300,
                                message: message,
                                delivered: message.delivered != null
                                    ? message.delivered!
                                    : false,
                                seen: message.seen != null
                                    ? message.seen!
                                    : false,
                              );
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
          Obx(()=>
             ChatMessageBar(
              textEditingController:chatController.textEditingController.value ,
              onsend: (value) async {
               if (chatController.textEditingController.value.text.isNotEmpty) {
                  chatController.btnSend.value = false;
          
                  //if it is send btn
                  bool delivered = false;
          
                  if (chatController.currentChatCustomer.value.status != null &&
                      chatController.currentChatCustomer.value.status ==
                          "online") {
                    delivered = true;
                  }
          
                  ChatMessage message = ChatMessage(
                      messagetype: "text",
                      sender: FirebaseAuth.instance.currentUser!.uid,
                      receiver: widget.customer.userid!,
                      delivered: delivered,
                      message: value,
                      sentat: DateTime.now());
          
                  await chatController.sendMessage(
                      message,widget.chatid);
                  chatController.sendNotificationMessage(
                      widget.chatid, widget.customer.token!, message);
                }
              },
              onCameraPressed: () {
                   Get.bottomSheet(
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Column(
                            children: [
                              Text("Add Photo".tr),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await chatController.ImagePickerFromCamera(
                                          widget.chatid, widget.customer);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                )),
                                            child: const Icon(
                                              Icons.image,
                                              color: Constants.textColor,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Camera".tr),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await chatController.ImagePickerFromGallery(
                                          widget.chatid, widget.customer);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                )),
                                            child: const Icon(
                                              Icons.image,
                                              color: Constants.textColor,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
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
               recordInSec: chatController.onLongpressed.value == true
                  ? chatController.recordingInMin.value
                          .toString()
                          .padLeft(2, "0") +
                      ":" +
                      chatController.recordingInSec.value
                          .toString()
                          .padLeft(2, "0")
                  : null,
              micShown: chatController.btnSend.value ? false : true,
              onTextChanged: (p0) {
                if (p0.isNotEmpty) {
                  chatController.btnSend.value = true;
                } else {
                  chatController.btnSend.value = false;
                }
              },
              onLongPress: () async {
                chatController.onLongpressed.value = true;
          
                bool isAllowed = await chatController.isAllowedToRecord();
                if (isAllowed) await chatController.startRecording();
              },
              onLongpressed: chatController.onLongpressed.value,
              onLongPressEnd: (val) async {
                chatController.onLongpressed.value = false;
                await chatController.stopRecorder();
                await chatController.sendVoiceMessage(
                    widget.chatid,
                    chatController.recordingInSec.value,
                    widget.customer,
                    chatController.recordingInMin.value
                            .toString()
                            .padLeft(2, "0") +
                        ":" +
                        chatController.recordingInSec.value
                            .toString()
                            .padLeft(2, "0"));
              },
            
            ),
          ),
        ],
      ),
    );
  }
}
