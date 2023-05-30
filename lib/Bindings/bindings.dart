import 'package:dwa2y_pharmacy/Controllers/address_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/chat_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/googlemaps_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/location_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/notification_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/dashboard_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/product_controller.dart';
import 'package:get/get.dart';

import '../Controllers/localization_controller.dart';
import '../Controllers/myaccount_controller.dart';

class Binding implements Bindings{
  @override
  void dependencies() {
    Get.put(AuthController(),permanent: true);

    Get.put(LocationController(),permanent: true);
        Get.put(LanguageController(),permanent: true);
    Get.lazyPut(() => ChatController(),fenix: true);
    Get.put(NotificationController());
    Get.put(DashboardController(),permanent: true);
    Get.lazyPut(() => HomeController(),fenix: true);
    Get.lazyPut(() => OrderController(),fenix: true);
    Get.lazyPut(() => ProductController(),fenix: true);
    Get.lazyPut(() => MyAccountController(),fenix: true);
    Get.lazyPut(() => AddressController(),fenix: true);
    Get.lazyPut(() => GoogleMapServicers(),fenix: true);
  }

}