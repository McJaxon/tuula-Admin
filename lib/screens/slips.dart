import 'package:admin_banja/controllers/homePageController.dart';
import 'package:admin_banja/widgets/headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Slips extends StatefulWidget {
  const Slips({Key? key}) : super(key: key);

  @override
  State<Slips> createState() => _SlipsState();
}

class _SlipsState extends State<Slips> {
  final homeController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: const Color(0xff007981),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: IconButton(
            onPressed: () {
              // homeController.showHelpDialog(context);
            },
            icon: const Icon(Icons.question_mark, color: Colors.white70),
          )),
      body: Stack(
        children: <Widget>[
          PageHeader(
            heading: 'Slips',
          ),
          Positioned(
              left: 20.w,
              right: 20.w,
              top: 145.h,
              child: Text(
                'Your payment slips appear here ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 19.sp),
              )),
          Padding(
            padding: EdgeInsets.only(top: 245.h, left: 25.w, right: 25.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 200.h,
              ),
              Text(
                'You currently have no payment slips available',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
