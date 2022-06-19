import 'dart:ui';

import 'package:admin_banja/controllers/dashboard_controller.dart';
import 'package:admin_banja/controllers/loan_category_controller.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/widgets/loading_indicator.dart';
import 'package:admin_banja/widgets/network_error.dart';
import 'package:admin_banja/widgets/no_record_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppData extends StatefulWidget {
  const AppData({Key? key}) : super(key: key);

  @override
  State<AppData> createState() => _AppDataState();
}

class _AppDataState extends State<AppData> with TickerProviderStateMixin {
  var dashController = Get.put(DashboardController());
  var loanCategoryController = Get.put(LoanCategory());

  @override
  void initState() {
    dashController.tabController = TabController(length: 2, vsync: this);
    dashController.controller.addListener(() {
      if (dashController.controller.page == 0) {
        dashController.currentIndex.value = 0;
      } else {
        dashController.currentIndex.value = 1;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 238, 241),
      body: Stack(
        children: <Widget>[
          Stack(
            children: [
              FutureBuilder(
                  future: Future.wait(
                      [Server.fetchAllLoanCategories(), Server().fetchLoans()]),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingData();
                    } else if (snapshot.hasError) {
                      return const NetworkError();
                    } else if (snapshot.data == null) {
                      return const NoRecordError();
                    } else {
                      return Stack(children: [
                        PageView(
                          controller: dashController.tabPageController,
                          onPageChanged: (page) {
                            dashController.tabController
                                .animateTo(page.toInt());
                          },
                          children: [
                            Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: 240.h, bottom: 200.h),
                                  itemCount: snapshot.data[0]['payload'].length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        child: Padding(
                                          padding: EdgeInsets.all(24.w),
                                          child: Stack(
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data[0][
                                                                      'payload']
                                                                  [index]
                                                              ['loan_type'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 23.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Loan abbreviation:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                          snapshot.data[0][
                                                                      'payload']
                                                                  [index]
                                                              ['abbreviation'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
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
                                                          'Loan Type:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          snapshot.data[0][
                                                                      'payload']
                                                                  [index]
                                                              ['interest_type'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 18.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Minimum Amount:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          snapshot.data[0]
                                                                  ['payload']
                                                                  [index][
                                                                  'minimum_amount']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 18.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Maximum Amount:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          snapshot.data[0]
                                                                  ['payload']
                                                                  [index][
                                                                  'maximum_amount']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 18.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Text(
                                                      snapshot.data[0]
                                                              ['payload'][index]
                                                          ['description'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 18.sp),
                                                    ),
                                                  ]),
                                              Positioned(
                                                top: 0.h,
                                                right: 0.w,
                                                child: Container(
                                                  width: 160.w,
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      color:
                                                          Colors.blue.shade100),
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: TextButton(
                                                        child: Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontFamily:
                                                                  'Poppins'),
                                                        ),
                                                        onPressed: () {
                                                          loanCategoryController
                                                              .showEditLoanSheet(
                                                                  context,
                                                                  snapshot.data[
                                                                              0]
                                                                          [
                                                                          'payload']
                                                                      [index])
                                                              .then((value) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    const VerticalDivider(),
                                                    Expanded(
                                                      child: TextButton(
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: Colors.red,
                                                              fontFamily:
                                                                  'Poppins'),
                                                        ),
                                                        onPressed: () {
                                                          loanCategoryController
                                                              .confirmLoanTypeDelete(
                                                                  context,
                                                                  snapshot.data[
                                                                              0]
                                                                          [
                                                                          'payload']
                                                                      [
                                                                      index]['id'])
                                                              .then((value) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                Positioned(
                                  bottom: 35.h,
                                  right: 20.w,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        loanCategoryController
                                            .showCreateLoanSheet(context)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Colors.blue),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Add New Loan Category',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.sp),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              padding:
                                  EdgeInsets.only(top: 240.h, bottom: 200.h),
                              itemCount: snapshot.data[1]['payload'].length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    child: Padding(
                                      padding: EdgeInsets.all(26.w),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data[1]
                                                              ['payload'][index]
                                                          ['loan_type'],
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Applicant:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                          snapshot.data[1][
                                                                      'payload']
                                                                  [index]
                                                              ['full_names'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 16.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'NIN:',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                          snapshot.data[1]
                                                                  ['payload']
                                                              [index]['nin'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 16.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                CircleAvatar(
                                                    radius: 40.r,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      snapshot.data[1]
                                                              ['payload'][index]
                                                          ['profile_pic'],
                                                    )),
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.black38,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Amount:',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.sp),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'UGX ${snapshot.data[1]['payload'][index]['loan_amount']}/=',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 16.sp),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Payout:',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.sp),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'UGX ${snapshot.data[1]['payload'][index]['pay_back']}/=',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 18.sp),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Outstanding balance:',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.sp),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'UGX ${snapshot.data[1]['payload'][index]['outstanding_balance']}/=',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 18.sp),
                                                ),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ]);
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 132.0),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      color: Colors.white12,
                      child: TabBar(
                        controller: dashController.tabController,
                        onTap: (int page) {
                          dashController.tabCurrentPage = page;

                          dashController.tabPageController.animateToPage(
                              dashController.tabCurrentPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        tabs: const [
                          Tab(
                            child: Text(
                              'Loan Categories',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Publications',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                      'App Data',
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
