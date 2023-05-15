class AddressModel{
  String? addressTitle;
  String? phone;
  String ?googleAddress;

String ? label;
  double? lat,long;

  
  AddressModel({
     this.addressTitle,
     this.phone,
      this.googleAddress,
      this.label,
     this.lat,
     this.long,
  });
   factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        addressTitle: json["AddressTitle"] ?? "",
        phone: json["Phone"] ?? "",
        googleAddress: json["googleAddress"],
        label: json["label"],
        lat: json["lat"],
        long: json["long"],
        );
  }

 Map<String,dynamic> toJson()=>{
  "AddressTitle":addressTitle,
  "Phone":phone,
  "label":label,
  "googleAddress":googleAddress,
  "lat":lat,
  "long":long,
   };
}