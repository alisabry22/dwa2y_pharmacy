import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class DashboardController extends GetxController{

 PersistentTabController persistentTabController=PersistentTabController();
RxInt navBarIndex=0.obs;
void changeTabIndex(index)=>navBarIndex.value=index;


}