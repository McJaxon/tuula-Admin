import 'dart:ui';

import 'package:admin_banja/controllers/homePageController.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/widgets/loading_indicator.dart';
import 'package:admin_banja/widgets/network_error.dart';
import 'package:admin_banja/widgets/no_record_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<PaymentsPage> {
  final homeController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 238, 241),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: Server.fetchTransactionFlv(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingData();
                } else if (snapshot.hasError) {
                  return const NetworkError();
                } else if (snapshot.data == null) {
                  return const NoRecordError();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 65.h,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Text(
                                  //   'There are currently no payments made',
                                  //   style: TextStyle(
                                  //       color: Colors.black87,
                                  //       fontFamily: 'Poppins',
                                  //       fontWeight: FontWeight.w400,
                                  //       fontSize: 20.sp),
                                  // ),
                                  // Text(
                                  //   'UGX ' +
                                  //       snapshot.data['loan_amount']
                                  //           .toString() +
                                  //       '/=',
                                  //   style: TextStyle(
                                  //       color: Colors.black87,
                                  //       fontFamily: 'Poppins',
                                  //       fontWeight: FontWeight.w600,
                                  //       fontSize: 20.sp),
                                  // ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Total Amount Paid: ',
                              //       style: TextStyle(
                              //           color: Colors.black87,
                              //           fontFamily: 'Poppins',
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 20.sp),
                              //     ),
                              //     Text(
                              //       'UGX ' + snapshot.data['total_paid'] + '/=',
                              //       style: TextStyle(
                              //           color: Colors.black87,
                              //           fontFamily: 'Poppins',
                              //           fontWeight: FontWeight.w600,
                              //           fontSize: 20.sp),
                              //     ),
                              //   ],
                              // ),
                              // const Divider(),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Balance: ',
                              //       style: TextStyle(
                              //           color: Colors.black87,
                              //           fontFamily: 'Poppins',
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 24.sp),
                              //     ),
                              //     Text(
                              //       'UGX ' +
                              //           snapshot.data['outstanding_balance']
                              //               .toString() +
                              //           '/=',
                              //       style: TextStyle(
                              //           color: Colors.black87,
                              //           fontFamily: 'Poppins',
                              //           fontWeight: FontWeight.w600,
                              //           fontSize: 24.sp),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 95.h),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: 30.h, horizontal: 20.w),
                            itemCount: snapshot.data.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20.3,
                                            offset: const Offset(0.5, 0.1),
                                            spreadRadius: 0.5,
                                            color: Colors.teal[50]!)
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Padding(
                                    padding: EdgeInsets.all(26.w),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Paid By',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              const Spacer(),
                                              Text(
                                                snapshot.data[index]['customer']
                                                    ['name'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Email',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              const Spacer(),
                                              Text(
                                                snapshot.data[index]['customer']
                                                    ['email'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Phone',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              const Spacer(),
                                              Text(
                                                snapshot.data[index]['customer']
                                                    ['phone_number'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Paid Amount:',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                'UGX' +
                                                    snapshot.data[index]
                                                            ['charged_amount']
                                                        .toString() +
                                                    '/=',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Payment Date:',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                DateFormat.yMEd()
                                                    .format(DateTime.parse(
                                                        snapshot.data[index]
                                                            ['created_at']))
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Payment Status:',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                snapshot.data[index]['status']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Paid Using:',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${snapshot.data[index]['auth_model']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Transaction ID:',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${snapshot.data[index]['tx_ref']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                height: 140.h,
                width: double.infinity,
                color: Colors.white12,
                child: Padding(
                  padding: EdgeInsets.only(top: 24.h, right: 10.w),
                  child: Row(children: [
                    Container(
                      width: 50.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white12),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 25.w,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      'Payments',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
