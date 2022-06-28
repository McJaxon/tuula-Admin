import 'dart:ui';

import 'package:admin_banja/controllers/dashboard_controller.dart';
import 'package:admin_banja/controllers/loan_category_controller.dart';
import 'package:admin_banja/controllers/positions_controller.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/widgets/loading_indicator.dart';
import 'package:admin_banja/widgets/network_error.dart';
import 'package:admin_banja/widgets/no_record_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserRoles extends StatefulWidget {
  const UserRoles({Key? key}) : super(key: key);

  @override
  State<UserRoles> createState() => _UserRolesState();
}

class _UserRolesState extends State<UserRoles> with TickerProviderStateMixin {
  var dashController = Get.put(DashboardController());
  var loanCategoryController = Get.put(LoanCategory());
  var positionsController = Get.put(PositionsController());
    late TabController tabController;
  PageController controller = PageController();
  int tabCurrentPage = 0;
  var currentIndex = 0;
  PageController tabPageController = PageController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (controller.page == 0) {
        currentIndex = 0;
      } else {
        currentIndex = 1;
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
                  future: Future.wait([
                    Server.fetchAdminUsers(),
                    Server.fetchLoans(),
                    Server.fetchPositions()
                  ]),
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
                          controller: tabPageController,
                          onPageChanged: (page) {
                            tabController
                                .animateTo(page.toInt());
                          },
                          children: [
                            Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: 240.h, bottom: 200.h),
                                  itemCount: snapshot.data[0].length,
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
                                                          snapshot.data[0]
                                                                  [index]
                                                              ['full_names'],
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
                                                          'Email:',
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
                                                          snapshot.data[0]
                                                              [index]['email'],
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
                                                          'Position:',
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
                                                              [index]['name'],
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
                                                          'Email Verification:',
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
                                                          'Verified',
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
                                                          'Status:',
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
                                                          'Activated',
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
                                                  ]),
                                              // Positioned(
                                              //   top: 0.h,
                                              //   right: 0.w,
                                              //   child: Container(
                                              //     width: 90.w,
                                              //     height: 40.h,
                                              //     decoration: BoxDecoration(
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 10.r),
                                              //         color:
                                              //             Colors.blue.shade100),
                                              //     child: Row(children: [
                                              //       Expanded(
                                              //         child: TextButton(
                                              //           child: Text(
                                              //             'Action',
                                              //             style: TextStyle(
                                              //                 fontSize: 14.sp,
                                              //                 fontFamily:
                                              //                     'Poppins'),
                                              //           ),
                                              //           onPressed: () {
                                              //             loanCategoryController
                                              //                 .showEditLoanSheet(
                                              //                     context,
                                              //                     snapshot.data[
                                              //                                 0]
                                              //                             [
                                              //                             'payload']
                                              //                         [index])
                                              //                 .then((value) {
                                              //               setState(() {});
                                              //             });
                                              //           },
                                              //         ),
                                              //       ),
                                              //     ]),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),

                            Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: 240.h, bottom: 200.h),
                                  itemCount: snapshot.data[2].length,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot.data[2]
                                                              [index]['name'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Slug:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      16.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Text(
                                                              snapshot.data[2]
                                                                      [index]
                                                                  ['slug'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      16.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  snapshot.data[2][index]
                                                      ['description'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 18.sp),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Level:',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Text(
                                                      snapshot.data[2][index]
                                                              ['level']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 16.sp),
                                                    ),
                                                  ],
                                                ),
                                              ]),
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
                                        positionsController
                                            .showCreatePositionSheet(context)
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
                                                  'Add New Position',
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
                        controller: tabController,
                        onTap: (int page) {
                          tabCurrentPage = page;

                          tabPageController.animateToPage(
                              tabCurrentPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        tabs: const [
                          Tab(
                            child: Text(
                              'System Users',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          Tab(
                            child: Text(
                              'Positions',
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
                      'User Management',
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
