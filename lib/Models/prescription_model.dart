import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';

class PrescriptionOrder {
  String? userMadeOrder;
  List<String>? pickedImages;
  String? paymentMethod,orderStatus,acceptedby,orderid,amount;
  AddressModel? userAddress;
  String?text;
   DateTime? orderDate;
 bool? hideForCustomer,hideForPharmacy;
  String? orderType;

  PrescriptionOrder({
     this.userMadeOrder,
     this.userAddress,
     this.pickedImages,
     this.paymentMethod,
     this.orderType,
     this.acceptedby,
     this.orderDate,
     this.orderStatus,
     this.orderid,
     this.text,
        this.hideForCustomer,
     this.hideForPharmacy,
     this.amount,
  });

  factory PrescriptionOrder.fromDocumentSnapshot( DocumentSnapshot<Map<String,dynamic>> documentSnapshot) {
    return PrescriptionOrder(
        userMadeOrder:documentSnapshot.get("userMadeOrder")??"",
        orderid: documentSnapshot.id,
                   hideForCustomer:documentSnapshot.data().toString().contains("hideForCustomer")?documentSnapshot.get("hideForCustomer"):null,
            hideForPharmacy:documentSnapshot.data().toString().contains("hideForPharmacy")?documentSnapshot.get("hideForPharmacy"):null,
        userAddress:documentSnapshot.data().toString().contains("customerAddress")?AddressModel.fromJson(documentSnapshot.get("customerAddress")):AddressModel(),
        amount: documentSnapshot.get("amount")??"",
        pickedImages:documentSnapshot.data().toString().contains("Images")?(documentSnapshot.get("Images") as List).map((e) => e as String).toList():List.empty(),
        paymentMethod: documentSnapshot.get("paymentMethod") ?? "In Cash",
        acceptedby: documentSnapshot.get("Acceptedby")??"",
        orderDate: documentSnapshot.get("OrderDate").toDate()??"",
        text:documentSnapshot.data().toString().contains("text")?documentSnapshot.get("text"):"",
        orderStatus: documentSnapshot.get("OrderStatus")??"",
        orderType: documentSnapshot.get("OrderType") ?? "Delivery");
  }
   Map<String, dynamic> toJson()=>{
    "userMadeOrder":userMadeOrder,
  "acceptedby":  acceptedby,

    "pickedImages":pickedImages,
   "amount": amount,
    "OrderType":orderType,
    "orderStatus":orderStatus,
      "hideForPharmacy":hideForPharmacy,
  "hideForCustomer":hideForCustomer,
    "orderid":orderid,
    "text":text,
  };
}
