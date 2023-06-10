import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/chatmodel.dart';
import 'home_controller.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController{
  Rx<PharmacyModel> currentpharmacy=Get.find<HomeController>().currentpharmacy.value.obs;

    ScrollController scrollController=ScrollController();
      Rx<TextEditingController> textEditingController = TextEditingController().obs;
  RxBool btnSend = false.obs;
  RxBool onLongpressed = false.obs;
    StreamSubscription? listener;
    Rx<UserModel> currentChatCustomer=UserModel(lat: 0.0, long: 0.0).obs;
   RxString pickedFile="".obs;  

   //recordings variables
     FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
    FlutterSoundPlayer _player = FlutterSoundPlayer();
      RxString recordingFilePath = "".obs;
  RxInt recordingInSec = 0.obs;
  RxInt recordingInMin = 0.obs;
    RxInt totalDurationInSec = 0.obs;



  @override
  void onInit()async {
    super.onInit();
    Get.find<HomeController>().currentpharmacy.listen((p0) {
      currentpharmacy.value=p0;
    });
    getAllChats();
        await _myRecorder.openRecorder();
    await _player.openPlayer();
    _myRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

    @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
    
    _myRecorder.closeRecorder();
    _player.closePlayer();
  }
    @override
  void onClose() {
  
    super.onClose();
    if(listener!=null){
      listener!.cancel();
    }
       _myRecorder.closeRecorder();
    _player.closePlayer();
  }

   Future<void> seekPlayer(double value) async {
    await _player.seekToPlayer(Duration(seconds: value.toInt()));
  }

  Future fetchAudio(
    String url,
    String chatid,
    String filename,
  ) async {
    try {
    
   
      print("Chats/$chatid/$filename");
      Directory tempdir = await getApplicationDocumentsDirectory();
      String appdocumentspath = tempdir.path;
      File file = File('$appdocumentspath/$filename');
      if(await file.exists() && file.readAsBytes().toString().isNotEmpty){
          print("the file is there");
        }
      else{
          final voiceRef = FirebaseStorage.instance
          .ref()
          .child("Chats")
          .child(chatid)
          .child("$filename");
      DownloadTask downtask = voiceRef
          .writeToFile(file);
          
      downtask.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.paused:
            print("paused");
            break;
          case TaskState.canceled:
            print("cancelled");
            break;
          case TaskState.running:
            print("running");
            break;
          case TaskState.success:
            print("success");
            break;
          case TaskState.error:
            print("error");
            break;
      }
    
      });
    }
    }
     on FirebaseException catch (error) {
      print(error.message);
    }
  }
  
  Future<bool> checkvoicePermission() async {
    var audioPermission = await Permission.microphone.status;

    if (audioPermission.isGranted) {
      return true;
    } else if (audioPermission.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await Permission.microphone.request();
    }
    return false;
  }

  Future<bool> checkStoragePermission() async {
    var storagePermisson = await Permission.storage.status;

    if (storagePermisson.isGranted) {
      return true;
    } else if (storagePermisson.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await Permission.storage.request();
    }
    return false;
  }

  /// Check permission if speech is allowed or not
  Future<bool> isAllowedToRecord() async {
    var speech = await checkvoicePermission();
    var storage = await checkStoragePermission();
    return speech && storage;
  }

//start recording
  Future startRecording() async {
    await _myRecorder.openRecorder();
    await _myRecorder.startRecorder(toFile: 'audio');
    _myRecorder.onProgress!.listen((event) {
      print(event);
      recordingInMin.value = event.duration.inMinutes.remainder(60);
      recordingInSec.value = event.duration.inSeconds.remainder(60);
      totalDurationInSec.value = event.duration.inSeconds;
    });
  }

//stop the recorder
  Future<void> stopRecorder() async {
    recordingFilePath.value = (await _myRecorder.stopRecorder())!;
  }

  Future sendVoiceMessage(String chatid, int totalDurationInSec,
      UserModel customer, String duration) async {
    if (recordingFilePath.isNotEmpty) {
      final chatsRef =
          FirebaseStorage.instance.ref().child("Chats").child(chatid);

      File file = File(recordingFilePath.value);
      String path = DateTime.now().millisecondsSinceEpoch.toString()+".mp3";
      UploadTask uploadTask = chatsRef.child(path).putFile(
          file,
          SettableMetadata(
            contentType: 'audio/mp3',
          ));

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final downloadurl = await snapshot.ref.getDownloadURL();

      ChatMessage message = ChatMessage(
        sender: FirebaseAuth.instance.currentUser!.uid,
        receiver: customer.userid!,
        duration: duration,
        voiceFileName: path,
        totalDurationInSec: totalDurationInSec,
        delivered: currentChatCustomer.value.status != null &&
                currentChatCustomer.value.status == "online"
            ? true
            : false,
        message: "",
        voiceurl: downloadurl,
        sentat: DateTime.now().toLocal(),
        messagetype: "voice",
      );

      await FirebaseFirestore.instance
          .collection("Chats")
          .doc(chatid)
          .collection("messages")
          .add(message.toJson());
      await FirebaseFirestore.instance.collection("Chats").doc(chatid).update({
        "voice": message.voiceurl,
        "duration": duration,
        "sentat": message.sentat,
        "lastmessage": "voice",
        "customerTotalUnRead": FieldValue.increment(1)
      });

      await sendNotificationMessage(chatid, customer.token!, message);
    }
  }

 Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats(){
 return  FirebaseFirestore.instance.collection("Chats").where("receiverId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  }

  //start conversation between me and specific pharmacy
  Future sendMessage(ChatMessage message,String chatid)async{
 
  await FirebaseFirestore.instance.collection("Chats").doc(chatid).update({"lastmessage":message.message , "sentat":message.sentat,"customerTotalUnRead":FieldValue.increment(1)});
  await FirebaseFirestore.instance.collection("Chats").doc(chatid).collection("messages").add(message.toJson());
 
}

   

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId){
    return FirebaseFirestore.instance.collection("Chats").doc(chatId).collection("messages").orderBy("sentat",descending: true).snapshots();
  }

  Future getInitialUserDetails(String customerid)async{
    return FirebaseFirestore.instance.collection("users").doc(customerid).get().then((value)  {
      if(value.exists){
        return UserModel.fromDocumentSnapshot(value);
      }
    });
  }
    getCustomerStatusDetails(String customerid)  {

   listener=  FirebaseFirestore.instance
        .collection("users")
        .doc(customerid)
        .snapshots()
        .listen((event) {
          currentChatCustomer.value =
            UserModel.fromDocumentSnapshot(event);
           
        });
  }

 Future updateseenMessages(String chatId)async{

    QuerySnapshot<Map<String, dynamic>> query=  await FirebaseFirestore.instance.collection("Chats").doc(chatId).collection("messages").where("reciever",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      query.docs.forEach((element) {
        if(element.exists){
           element.reference.update({"seen":true});
        }
       
      });

      await FirebaseFirestore.instance.collection("Chats").doc(chatId).update({"pharmacyTotalUnRead":0});
  }
  
  
  Future updateMessageStatus(String chatId,String messageId)async{
    await FirebaseFirestore.instance.collection("Chats").doc(chatId).collection("messages").doc(messageId).update({"seen":true});
    await FirebaseFirestore.instance.collection("Chats").doc(chatId).get().then((value) {
        if(value.exists&& value.get("pharmacyTotalUnRead")!=0){
            value.reference.update({"pharmacyTotalUnRead":FieldValue.increment(-1)});
        }
    });
  }

  
  //send image from camera

  Future ImagePickerFromCamera(String chatId,UserModel customer)async{
    
   XFile? imagepick=await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 60);
   if(imagepick!=null){
      pickedFile.value=imagepick.path;
   String downloadurl=  await uploadPickedImageToStorage(chatId);
      sendImageMessage(chatId, downloadurl, customer);
   }
  }
  //send image from gallery
     Future ImagePickerFromGallery(String chatId,UserModel customer)async{
    
   XFile? imagepick=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 60);
   if(imagepick!=null){
pickedFile.value=imagepick.path;   
   String downloadurl=  await uploadPickedImageToStorage(chatId);
      sendImageMessage(chatId, downloadurl, customer);
}
  }
  Future sendImageMessage(String chatId,String downloadurl,UserModel customer)async{
    

    ChatMessage message=ChatMessage(
      message: "",
      messagetype: "image",
      receiver: customer.userid!,
      sender: FirebaseAuth.instance.currentUser!.uid,
      sentat: DateTime.now().toLocal(),
      delivered: currentChatCustomer.value.status != null &&currentChatCustomer.value.status == "online"?true:false,
      pictureMessage:downloadurl,
    );
        await FirebaseFirestore.instance.collection("Chats").doc(chatId).update({"lastmessage":"Photo","customerTotalUnRead":FieldValue.increment(1)});

    await FirebaseFirestore.instance.collection("Chats").doc(chatId).collection("messages").add(message.toJson());
  await sendNotificationMessage(chatId, customer.token!, message);
  }

   Future? uploadPickedImageToStorage(String chatid)async{
    final chatsRef=FirebaseStorage.instance.ref("Chats/$chatid");
    String downloadurl="";
      if(pickedFile.value.isNotEmpty){
          await chatsRef.putFile(File(pickedFile.value));
          downloadurl=await chatsRef.getDownloadURL();
    }
    if(downloadurl.isNotEmpty){
      return downloadurl;
    }else{
      return null;
    }

  
  }

  Future sendNotificationMessage(String chatID,String token,ChatMessage message)async{
     try {
      print("${currentpharmacy.value.userid} currentpharmacy.value.userid");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":
              'key=AAAAGEPFvzA:APA91bHJ-aoqR1ln8I_YOaSrfKKnDHacd_Em6Hd70hDc_yL75ON6ITboslu7C-0_uhuDyPV9GlMoE_BWupL4vClcISlaksTi5qGtw78FkcRA8WkXFMh0HMLBsmx7kwg4mU8OcouaRBG-',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'chat',
            "message":message.message,
            "sender":message.sender,
            "pharmacy":currentpharmacy.value.pharmacyModeltoJson(),
            "chatId":chatID,
            "receiver":message.receiver,
        

          },
          'notification': {
           "title":currentpharmacy.value.username,
           "android_channel_id": 'high_importance_channel',
           "body":message.message,
           "image":message.messagetype=="image"?message.pictureMessage:null,

          },
          'to': token,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }
  
}


