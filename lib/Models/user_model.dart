
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';

class UserModel {
  String? username, phone, countrycode, profileImageLink, createdAt,updatedAt,gender,birthday,email,userid,token;
 final double lat,long;
List<AddressModel>? addresses;
int? defaultAddressIndex;
String? status;

  UserModel({

     this.username,
     this.phone,
     this.countrycode,
     this.profileImageLink,
     this.status,
     this.gender,
     this.birthday,
     this.email,
    required this.lat,
    required this.long,
    this.defaultAddressIndex,
    this.userid,
  this.token,
     this.createdAt,
     this.updatedAt,
     this.addresses,
  });
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      username:documentSnapshot.data().toString().contains("username")? documentSnapshot.get("username"):"",
      userid: documentSnapshot.id,
     status:documentSnapshot.data().toString().contains("status")?documentSnapshot.get("status"):"",

      phone:documentSnapshot.data().toString().contains("phone")? documentSnapshot.get("phone"):"",
      token: documentSnapshot.data().toString().contains("token")?documentSnapshot.get("token"):"",
      createdAt:documentSnapshot.data().toString().contains("createdAt")? documentSnapshot.get("createdAt"):"",
      profileImageLink: documentSnapshot.data().toString().contains("profileImageLink")?documentSnapshot.get("profileImageLink"):"",
      updatedAt:documentSnapshot.data().toString().contains("updatedAt")? documentSnapshot.get("updatedAt"):"",
      lat: documentSnapshot.data().toString().contains("lat")?documentSnapshot.get("lat"):0.0,
      long: documentSnapshot.data().toString().contains("long")?documentSnapshot.get("long"):0.0,
      countrycode:documentSnapshot.data().toString().contains("countryCode")? documentSnapshot.get("countryCode"):"",
     addresses:documentSnapshot.data().toString().contains("address")?documentSnapshot.get("address").map<AddressModel>((m)=>AddressModel.fromJson(m)).toList():<AddressModel>[],
      birthday:documentSnapshot.data().toString().contains("birthday")? documentSnapshot.get("birthday"):"",
      gender: documentSnapshot.data().toString().contains("gender")?documentSnapshot.get("gender"):"",
      email: documentSnapshot.data().toString().contains("email")?documentSnapshot.get("email"):"",
      defaultAddressIndex:documentSnapshot.data().toString().contains("defaultAddressIndex")? documentSnapshot.get("defaultAddressIndex"):0,
          );
  }

  Map<String, dynamic> userModelToJson() => {
        "username": username,
        "phone": phone,
        "countryCode": countrycode,
        "birthday":birthday,
        "gender":gender,
        "email":email,
        "defaultAddressIndex":defaultAddressIndex,
        "profileImageLink": profileImageLink,
        "lat":lat,
        "long":long,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "address":addresses,
      };
}
