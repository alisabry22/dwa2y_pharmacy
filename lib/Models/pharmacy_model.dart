import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';

class PharmacyModel {
  String? username,
      phone,
      countrycode,
      profileImageLink,
      createdAt,
      updatedAt,
      email,
      userid,token;
  final double lat, long;
  AddressModel? address;

  PharmacyModel({
    this.username,
    this.phone,
    this.countrycode,
    this.profileImageLink,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.userid,
    this.token,
    required this.lat,
    required this.long,
    this.address,
  });

  factory PharmacyModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PharmacyModel(
      lat:doc.data().toString().contains("lat")? doc.get("lat"):0.0,
      long:doc.data().toString().contains("long")?doc.get("long"):0.0,
      username:doc.data().toString().contains("username")? doc.get("username"):"",
      userid: doc.id,
      address:doc.data().toString().contains("address")?AddressModel.fromJson(doc.get("address")):AddressModel(),
      countrycode: doc.data().toString().contains("lat")?doc.get("countryCode"):"EG",
      phone: doc.data().toString().contains("lat")?doc.get("phone"):"",
      profileImageLink:doc.data().toString().contains("lat")? doc.get("profileImageLink"):"",
      email:doc.data().toString().contains("lat")? doc.get("email"):"",
      token: doc.data().toString().contains("token")?doc.get("token"):"",
      createdAt:doc.data().toString().contains("lat")? doc.get("createdAt"):"",
      updatedAt: doc.data().toString().contains("lat")?doc.get("updatedAt"):"",
    );
  }

   Map<String, dynamic> pharmacyModeltoJson() => {
        "username": username,
        "phone": phone,
        "countryCode": countrycode,
        "profileImageLink": profileImageLink,
        "lat":lat,
        "long":long,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
  

        "email":email
      };
}
