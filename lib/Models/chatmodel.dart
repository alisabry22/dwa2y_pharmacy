class ChatMessage {
  String sender;
  String receiver;
  String message;
  DateTime sentat;
  bool? delivered;
  bool? seen;
   String messagetype;
  String? pictureMessage;
    String? voiceurl;
  String?duration;
  int? totalDurationInSec;
  String? voiceFileName;
    double? position;
// Add additional properties like image URL, seen status, etc.

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentat,
      required this.messagetype,
        this.pictureMessage,
    this.seen,
    this.delivered,
            this.duration,
  this.totalDurationInSec,
          this.voiceFileName,
        this.voiceurl,
        this.position=0,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
     sender: json["sender"],
        messagetype:json["messagetype"],
        voiceFileName:json["voiceFileName"],
        voiceurl:json["voice"],
      pictureMessage:json["pictureMessage"]!=null?json["pictureMessage"]:null,
        delivered: json["delivered"]!=null?json["delivered"]:false,
        seen: json["seen"]!=null?json["seen"]:false,
        receiver: json["reciever"],
        
        message: json["message"],
        totalDurationInSec:json["totalDurationInSec"],
        duration:json["duration"],
        sentat: json["sentat"].toDate());
        
        
  }

  Map<String, dynamic> toJson() => {
  "sender": sender,
        "delivered":delivered,
        "seen":seen,
        "voice":voiceurl,
        "duration":duration,
        "totalDurationInSec":totalDurationInSec,
        "voiceFileName":voiceFileName,
        "pictureMessage":pictureMessage,
        "messagetype":messagetype,
        "reciever": receiver,
        "message": message,
        "sentat": sentat,
      };
}
