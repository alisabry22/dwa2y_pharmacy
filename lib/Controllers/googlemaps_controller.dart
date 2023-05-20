
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/location_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../Models/placeautocomplete_prediction.dart';
import '../Widgets/custom_elevated_button.dart';

class GoogleMapServicers extends GetxController {
  final locationController=Get.find<LocationController>();

  Rx<TextEditingController> searchPlace = TextEditingController().obs;
  RxDouble latitude = Get.find<LocationController>().lat;
  RxDouble longitude =Get.find<LocationController>().long;
  GoogleMapController? mapController;
  RxString fullAddress="".obs;
    RxList<PlaceAutoCompletePrediction> placePredictions=RxList.empty();
    

  RxDouble zoomvalue=14.402209281921387.obs;
    late Position positionSetting;



  Rx<CameraPosition> cameraPosition = const CameraPosition(
          target: LatLng(20.42796133580664, 75.885749655962), zoom: 14.402209281921387)
      .obs;
  RxList<Marker> markers = [
   const Marker(
      markerId: MarkerId("1"),
      position: LatLng(20.42796133580664, 75.885749655962),
      infoWindow: InfoWindow(title: "My Position"),
    ),
  ].obs;

  Rx<PharmacyModel> currentUserData = PharmacyModel(lat:0.0,long:0.0).obs;

  RxString currentuserID = "".obs;

  @override
  void onInit() async {
    currentUserData.value = await getInitialData();
    currentUserData.bindStream(getCrruntUserData());
    
   ever(currentUserData, _changeValues);


    cameraPosition.value = CameraPosition(target: LatLng(latitude.value,longitude.value), zoom: zoomvalue.value);
    getCurrentAddress();
   
  updateMarkers();
    super.onInit();
  }

  Future<PharmacyModel> getInitialData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return PharmacyModel.fromDocumentSnapshot(snapshot);
  }

  void updateMarkers(){
        markers.clear();
     markers.value = [
      Marker(
        markerId:const MarkerId("1"),
        position: LatLng(latitude.value, longitude.value),
        infoWindow:const InfoWindow(title: "My Position"),
      )
    ];
    markers.refresh();
  }

  Stream<PharmacyModel> getCrruntUserData() {
    return FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) {
      return PharmacyModel.fromDocumentSnapshot(event);
    });
  }

  updateCameraPosition() async {
    cameraPosition.value =
        CameraPosition(target: LatLng(latitude.value, longitude.value));
    await mapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition.value));
  }

  //TODO: still not working
  // Future updateLocation(String query) async {
  //   Uri uri = Uri.https(
  //       "maps.googleapis.com", "maps/api/place/autocomplete/json", {

  //         "input":query,
  //         "key":"AIzaSyDpN41FPAh1IOl98J8doMvLBjD_11Z93Nw",

  //       });

     
  // final response=await http.get(uri);

  // if(response.statusCode==200){
  //   print(jsonDecode(response.body));
  //   PlacesAutoCompleteResponse placeresponse=PlacesAutoCompleteResponse.parseAutoCompleteResult(response.body);
  //   if(placeresponse.predictions!=null){
  //     print(placeresponse.predictions!.length);
  //     placePredictions.value=placeresponse.predictions!;
  //     placePredictions.refresh();
  //   }
  // }

  // }

//to get current lat and long of choosen address from search
  Future getLatAndLong(String placeId,String description)async{

    GoogleMapsPlaces  mapsPlaces= GoogleMapsPlaces(apiKey:"AIzaSyClHN31_AJxOD2z9LzWZ8i9UgVsBoL3ftE" );
    PlacesDetailsResponse placesDetailsResponse=  await mapsPlaces.getDetailsByPlaceId(placeId);

    latitude.value=placesDetailsResponse.result.geometry!.location.lat;
    longitude.value=placesDetailsResponse.result.geometry!.location.lng;


    updateCameraPosition();
    updateMarkers();


  }

  Future updateFirebaseLocation()async{

    final data={
      "lat":latitude.value,
      "long":longitude.value,

    };
    await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update(data);

  }

    Future getCurrentLocation()async {
      
    try {
  positionSetting = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best );
  latitude.value=positionSetting.latitude;
  longitude.value=positionSetting.longitude;
} on Exception catch (e) {
          await Get.defaultDialog(
      title: "Error",
      content: Text("$e"),
      actions: [
        CustomElevatedButton(width: 120, height: 60, onPressed: (){
          Get.back();
        }, text: "Ok"),
      ]
    );
}
  updateFirebaseLocation();
  updateCameraPosition();

  }

  _changeValues(PharmacyModel userModel) {

    updateMarkers();
  }

  Future getCurrentAddress()async{
    List<Placemark> placemarks=await placemarkFromCoordinates(latitude.value, longitude.value);
    String? address="  ${placemarks.first.thoroughfare!} - ${placemarks.first.locality!} - ${placemarks.first.subAdministrativeArea}";
    fullAddress.value=address;
  }
}
