
import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


import '../Controllers/localization_controller.dart';
import '../Models/chatmodel.dart';

class VoiceBubble extends StatefulWidget {

 final ChatMessage message;
  final bool delivered;
  final bool seen;
  final bubblecolor;
   VoiceBubble({
  required this.message,
      required this.delivered,
      required this.seen,
       this.bubblecolor=Colors.white24,
  });

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
 String currentUser= FirebaseAuth.instance.currentUser!.uid;
  bool isPlaying = false;
  FlutterSoundPlayer _player = FlutterSoundPlayer();
   late  double sliderValue;
     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValue=0;
      _player.openPlayer();
        _player.setSubscriptionDuration(const Duration(milliseconds: 100));

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.closePlayer();
  }

  bool isPause = false;
  @override
  Widget build(BuildContext context) {
    bool isSender=widget.message.sender==FirebaseAuth.instance.currentUser!.uid;
     Icon? icon;
    if(isSender&&widget.delivered){
      icon=Icon(Icons.done_all,color: Colors.grey,size: 16,);
    }
    if(isSender&&widget.seen){
      icon=Icon(Icons.done_all,color: Colors.green,size: 16,);
    }
     if(isSender && !widget.delivered && !widget.seen){
       icon=Icon(Icons.done,color: Colors.grey,size: 16,);
    }  
   final localeCont=Get.find<LanguageController>().locale.value;
    return    Row(
        children: <Widget>[
          
         isSender ? Container()
              : Expanded(
                  child: SizedBox(
                    width: 5,
                  ),
                ),
          Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8, maxHeight: 70),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.bubblecolor,
                  borderRadius: BorderRadius.only(
                    topLeft:   isSender ? Radius.circular(14) : Radius.circular(0),
                    topRight:    isSender ? Radius.circular(0) : Radius.circular(14),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: [
                    
                        RawMaterialButton(
                              onPressed: (){
                             playAudio(  widget.message.voiceurl!,   widget.message.voiceFileName!);
                              },
                              elevation: 1.0,
                              fillColor: Colors.white,
                              child: !isPlaying
                                  ? Icon(
                                      Icons.play_arrow,
                                      size: 24.0,
                                    )
                                
                                      : 
                                           Icon(
                                              Icons.pause,
                                              size: 24.0,
                                            ),
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder(),
                            ),
                          
                          Expanded(
                            child: 
                              
                             
                              Slider(
                                    value:sliderValue,
                                    min: 0.0,
                                   
                                          inactiveColor: isSender?Colors.white:Colors.grey,
                                    activeColor:isSender?Colors.white:Colors.blue ,
                                    max: widget.message.totalDurationInSec!=null?double.parse(widget.message.totalDurationInSec.toString()):0.0,
                                    onChanged: (p0) {
                                      
                                    },
                                  
                                                             ),
                               ),
                            
                        ]
                          ),
                    ),
                         Positioned(
                      bottom: 1,
                      right: localeCont.languageCode != "ar" ? 140 : null,
                      left: localeCont.languageCode == "ar" ? 140 : null,
                      child: Text(
                       widget.message.duration!,
                        style: TextStyle(color:isSender?Colors.white: Colors.black,fontSize: 11),
                      ),
                    ),
                       Positioned(
                      bottom: 1,
                      right: localeCont.languageCode != "ar" ? 5 : null,
                      left: localeCont.languageCode == "ar" ? 5 : null,
                      child:   icon!=null?  icon:Container(),
                    ),
                        Positioned(
                            right: localeCont.languageCode != "ar" ? 30 : null,
                            left: localeCont.languageCode == "ar" ? 30 : null,
                            bottom: 0,
                            child: Text(
                              int.parse(widget.message.sentat
                                          .toString()
                                          .substring(11, 13)) >=
                                      12
                                  ? "${int.parse(widget.message.sentat.toString().substring(11, 13)) - 12}:${widget.message.sentat.toString().substring(14, 16)}${"PM".tr}"
                                  : "${widget.message.sentat.toString().substring(11, 16)}${"AM".tr}",
                              style: TextStyle(     color:isSender?Colors.white: Colors.black,fontSize: 11),),)
                        ],
                      ),
                  
               
                
            
              ),),),],        
              );
            
              
  
}
void playAudio(String audiourl, String filename) async {

    if (isPause) {
      await _player.resumePlayer();
    setState(() {
        isPlaying = true;
     isPause = false;
    });
    } else if (isPlaying) {
      await _player.pausePlayer();
     setState(() {
        isPlaying=false;
      isPause=true;
     });
    } else {
      Directory tempdir = await getApplicationDocumentsDirectory();
      String appdocumentspath = tempdir.path;
      print('$appdocumentspath/$filename');
      await _player.openPlayer();
      await _player.startPlayer(
        fromURI: '$appdocumentspath/$filename',
        whenFinished: (){setState(() {
          isPlaying=false;
          sliderValue=0;
        });},
        
      );
      _player.onProgress!.listen((event) {
      
        setState(() {
            sliderValue=event.position.inSeconds.toDouble();
        });
      
      });
    setState(() {
       isPlaying=true;
    });
    }
  }
}

                              
  