import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {

  String? prodcutId,productName,productImage,pharmacyId,productCategory,pharmacyName;
  int? discountPercent,afterDiscount,productPrice;

  ProductModel({
    this.prodcutId,
    this.productName,
    this.productImage,
    this.pharmacyId,
    this.productPrice,
    this.discountPercent,
    this.afterDiscount,
    this.productCategory,
    this.pharmacyName,
  });
  Map<String, dynamic> toMap() {
    return {
      'prodcutId':prodcutId,
      'pharmacyName':pharmacyName,
      'productName':productName,
      'productPrice':productPrice,
      'productImage':productImage,
      'pharmacyId': pharmacyId,
      'discountPercent':discountPercent,
      'afterDiscount':afterDiscount,
      'productCategory':productCategory
    };
  }

  factory ProductModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ProductModel(
      prodcutId:doc.id,
      pharmacyName:doc.get("pharmacyName")??"",
      productName:doc.get("productName")??"",
      productPrice:doc.get("productPrice")??"",
      productImage:doc.get("productImage")??"",
      pharmacyId: doc.get("pharmacyId")??"",
      productCategory: doc.get("productCategory")??"",
      discountPercent:doc.get("discountPercent")??0,
      afterDiscount:doc.get("afterDiscount")??0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromDocumentSnapshot(json.decode(source));
}
