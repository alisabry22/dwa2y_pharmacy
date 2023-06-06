class AddressModel{
  String? street;
  String? floor;
  String? nearby;
  String? apartmentNumber;
  String ?googleAddress;
String ? label;
  double? lat,long;
String? city;
String? blocknumber;
  
  AddressModel({
     this.street,
     this.apartmentNumber,
     this.nearby,
     this.floor,
     this.city,
     this.blocknumber,
      this.googleAddress,
     this.label,

     this.lat,
     this.long,
  });
   factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        street: json["street"] ?? "",
        city:json["city"]??"",
        blocknumber: json["blocknumber"]??"",
        floor: json["floor"] ?? "",
        googleAddress: json["googleAddress"],
        nearby: json["nearby"]??"",
        apartmentNumber: json["apartmentNumber"]??"",
        lat: json["lat"],
        long: json["long"],
                label: json["label"]??"",

        );
  }

 Map<String,dynamic> toJson()=>{
  "street":street,
  "nearby":nearby,
  "apartmentNumber":apartmentNumber,
  "googleAddress":googleAddress,
  "floor":floor,
  "lat":lat,
  "long":long,
    "label":label,

   };
}