import 'package:admin_banja/services/server.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DashboardController extends GetxController {

  var dashboardData = [].obs;




  @override
  void onReady() async {
    super.onReady();
    //Server().fetchData();
  }
}