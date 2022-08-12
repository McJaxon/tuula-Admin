import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/server.dart';

class UserController extends GetxController {
  var users = [].obs;

  getUsers() async {
    if (GetStorage().read('accessToken') != null) {
      users.value = await Server.fetchUsers();
    }
  }

  @override
  void onInit() {
    getUsers();

    super.onInit();
  }
}
