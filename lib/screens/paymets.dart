import 'package:admin_banja/controllers/homePageController.dart';
import 'package:admin_banja/widgets/headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final homeController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageHeader(
            heading: 'My Records',
          ),
          Positioned(
              left: 20.w,
              right: 20.w,
              top: 145.h,
              child: Text(
                'Loan and payment history details appear here',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 19.sp),
              )),
          Padding(
            padding: EdgeInsets.only(top: 245.h, left: 25.w, right: 25.w),
            child: ListView.builder(itemBuilder: (context, index) {
              return Container();
            }),
          )
        ],
      ),
    );
  }
}
