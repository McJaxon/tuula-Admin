import 'package:admin_banja/controllers/user_details_controller.dart';
import 'package:admin_banja/screens/auth/register_page.dart';
import 'package:admin_banja/screens/dash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/loan_detail_controllers.dart';

class Pager extends StatefulWidget {
  const Pager({Key? key}) : super(key: key);

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  @override
  Widget build(BuildContext context) {
    Get.put(LoanController());
    Get.put(UserController());
    bool status = GetStorage().read('isLoggedIn') ?? false;
    return !status ? const RegisterPage() : const Dash();
  }
}
