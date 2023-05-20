class AddressModel{
  String? street;
  String? floor;
  String? nearby;
  String? apartmentNumber;
  String ?googleAddress;

  double? lat,long;

  
  AddressModel({
     this.street,
     this.apartmentNumber,
     this.nearby,
     this.floor,
     
      this.googleAddress,

     this.lat,
     this.long,
  });
   factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        street: json["street"] ?? "",
        floor: json["floor"] ?? "",
        googleAddress: json["googleAddress"],
        nearby: json["nearby"]??"",
        apartmentNumber: json["apartmentNumber"]??"",
        lat: json["lat"],
        long: json["long"],
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
   };
}