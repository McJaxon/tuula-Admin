import 'dart:ui';

import 'package:admin_banja/controllers/loan_detail_controllers.dart';
import 'package:admin_banja/controllers/user_details_controller.dart';
import 'package:admin_banja/screens/more_detail_dash.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/widgets/percentage_card.dart';
import 'package:admin_banja/widgets/side_drawer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import 'auth/register_page.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> with TickerProviderStateMixin {
  var dashController = Get.put(DashboardController());
  LoanController loanController = Get.find();
  DashboardController dashBController = Get.find();
  UserController users = Get.find();
  List<BoxShadow> shadowList = [
    const BoxShadow(
        color: Colors.grey, blurStyle: BlurStyle.normal, offset: Offset(0, 10))
  ];

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
        backgroundColor: const Color.fromARGB(255, 8, 157, 168),
        body: GestureDetector(
          onTap: () async {
            dashController.sliderKey.currentState?.closeSlider();
          },
          child: Row(
            children: [
              SliderView(),
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 200, 227, 229),
                  child: Stack(children: [
                    PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: dashController.controller,
                      children: [
                        CupertinoScrollbar(
                          child: ListView(
                            padding: EdgeInsets.only(top: 200.h),
                            physics: const BouncingScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 45.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Last Updated: ${DateFormat().format(DateTime.now())}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16.sp)),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0),
                                    Wrap(
                                      runSpacing: 10.0,
                                      spacing: 10.0,
                                      children: [
                                        Container(
                                            height: 160.h,
                                            width: 260.w,
                                            decoration: BoxDecoration(
                                                boxShadow: shadowList,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 255, 115, 0)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Total Applications',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 20.sp)),
                                                      Obx(() {
                                                        return Text(
                                                            '${loanController.loanApplications.length}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    26.sp));
                                                      })
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            bottom: 0,
                                                            right: 5),
                                                        height: 45,
                                                        width: 45,
                                                        child: Image.asset(
                                                          'assets/images/loan_app.png',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )),
                                        Container(
                                            height: 160.h,
                                            width: 260.w,
                                            decoration: BoxDecoration(
                                                boxShadow: shadowList,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 0, 157, 255)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('All users',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 20.sp)),
                                                      Obx(() {
                                                        return Text(
                                                            '${users.users.length}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    26.sp));
                                                      })
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            bottom: 0,
                                                            right: 5),
                                                        height: 45,
                                                        width: 45,
                                                        child: Image.asset(
                                                          'assets/images/users.png',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )),
                                        Container(
                                            height: 160.h,
                                            width: 260.w,
                                            decoration: BoxDecoration(
                                                boxShadow: shadowList,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 49, 174, 0)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Total Loan amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 20.sp)),
                                                      Obx(() {
                                                        return Text(
                                                            'UGX${NumberFormat.decimalPattern().format(loanController.totalLoanAmount.value)}',
                                                            style: TextStyle(
                                                                color:
                                                                    const Color.fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    26.sp));
                                                      })
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            bottom: 0,
                                                            right: 5),
                                                        height: 45,
                                                        width: 45,
                                                        child: Image.asset(
                                                          'assets/images/money.png',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )),
                                        Container(
                                            height: 160.h,
                                            width: 260.w,
                                            decoration: BoxDecoration(
                                                boxShadow: shadowList,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 103, 0, 132)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Total Transfers',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 20.sp)),
                                                      Text('UGX0',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 26.sp))
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            bottom: 5,
                                                            right: 5),
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                          'assets/images/saving.png',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 45.w, top: 25.h, right: 45.w),
                                child: SizedBox(
                                    height: 225.h,
                                    child: Obx(() {
                                      return dashController
                                              .dashBoardData.isEmpty
                                          ? const Center(
                                              child: Text(
                                              'No laon applications so far',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 19),
                                            ))
                                          : Swiper(
                                              itemCount: dashController
                                                  .dashBoardData.length,
                                              autoplay: true,
                                              autoplayDelay: 6000,
                                              controller:
                                                  dashController.cardController,
                                              itemWidth: 475.w,
                                              layout: SwiperLayout.STACK,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                dashController.currentCard =
                                                    index + 1;
                                                return PercentageCard(
                                                  dashController: dashController
                                                      .dashBoardData,
                                                  index: index,
                                                );
                                              },
                                            );
                                    })),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 30.0, left: 45.w, right: 45.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Yearly Statistics - Loan Applicants',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            fontSize: 18.sp),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        height: 240.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22.r),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 44.h,
                                              left: 10.w,
                                              right: 10.w),
                                          child: Obx(() {
                                            return dashController
                                                    .dashBoardData.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                    'No data to display',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 19),
                                                  ))
                                                : BarChart(
                                                    BarChartData(
                                                      barTouchData:
                                                          barTouchData,
                                                      titlesData: dashController
                                                          .titlesEducationData,
                                                      borderData: borderData,
                                                      barGroups: List.from(
                                                          dashController
                                                              .dashBoardData[
                                                                  'yearly_stats']
                                                                  ['2023']
                                                              .map(
                                                        (value) =>
                                                            BarChartGroupData(
                                                          x: dashController
                                                              .dashBoardData[
                                                                  'yearly_stats']
                                                                  ['2023']
                                                              .indexOf(value),
                                                          barRods: [
                                                            BarChartRodData(
                                                                y: double.parse(
                                                                    value['count']
                                                                        .toString()),
                                                                colors: [
                                                                  Colors
                                                                      .lightBlueAccent,
                                                                  Colors
                                                                      .greenAccent
                                                                ])
                                                          ],
                                                          showingTooltipIndicators: [
                                                            0
                                                          ],
                                                        ),
                                                      )),
                                                      alignment:
                                                          BarChartAlignment
                                                              .spaceAround,
                                                    ),
                                                  );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 100.0,
                              ),
                              Obx(() {
                                return dashController.dashBoardData.isEmpty
                                    ? const SizedBox.shrink()
                                    : CurrentLoanApplications(
                                        currentApplications: dashBController
                                                    .dashBoardData[
                                                        'pending_loan_applications']
                                                    .length ==
                                                0
                                            ? []
                                            : dashController.dashBoardData[
                                                'pending_loan_applications']);
                              }),
                              Obx(() {
                                return dashController.dashBoardData.isEmpty
                                    ? const SizedBox.shrink()
                                    : DefaulterSection(
                                        defaulter: dashController
                                            .dashBoardData['loan_defaulters']);
                              }),
                              SizedBox(
                                height: 170.h,
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Stack(
                            children: [
                              Stack(children: [
                                PageView(
                                  controller: dashController.tabPageController,
                                  onPageChanged: (page) {
                                    dashController.tabController
                                        .animateTo(page.toInt());
                                  },
                                  children: [
                                    ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: 240.h, bottom: 200.h),
                                      itemCount: users.users.length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding: EdgeInsets.all(26.w),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 125.r,
                                                          height: 125.r,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          75,
                                                                          126,
                                                                          255),
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                        CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            radius: 60.r,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              users.users[index]
                                                                  [
                                                                  'profile_pic'],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  users.users[
                                                                          index]
                                                                      [
                                                                      'full_names'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          25.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Gender:',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              18.sp),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Text(
                                                                      users.users[index]
                                                                              [
                                                                              'gender'] ??
                                                                          '',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              18.sp),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Age:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                          [
                                                                          'dob'] !=
                                                                      null
                                                                  ? users.users[
                                                                              index]
                                                                          [
                                                                          'dob'] +
                                                                      ' (${DateTime.now().year - int.parse(users.users[index]['dob'].split('-')[0])})yrs'
                                                                  : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Location:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                  ['location'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Phone number:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                  [
                                                                  'phone_number'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
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
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                  ['email'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Profession:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                      [
                                                                      'profession'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Loan Purpose:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              users.users[index]
                                                                      [
                                                                      'loan_purpose'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Next of Kin:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              (users.users[index]
                                                                          [
                                                                          'next_of_kin'] ??
                                                                      '')
                                                                  .split(
                                                                      '-')[0],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: 240.h, bottom: 200.h),
                                      itemCount: loanController
                                          .loanApplications.length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding: EdgeInsets.all(26.w),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              loanController
                                                                          .loanApplications[
                                                                      index]
                                                                  ['loan_type'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      23.sp),
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
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Text(
                                                                  loanController
                                                                              .loanApplications[
                                                                          index]
                                                                      [
                                                                      'full_names'],
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
                                                            SizedBox(
                                                                height: 5.h),
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
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Text(
                                                                  loanController
                                                                          .loanApplications[
                                                                      index]['nin'],
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
                                                        const Spacer(),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              width: 105.r,
                                                              height: 105.r,
                                                              decoration: const BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          75,
                                                                          126,
                                                                          255),
                                                                  shape: BoxShape
                                                                      .circle),
                                                            ),
                                                            CircleAvatar(
                                                                radius: 50.r,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  loanController
                                                                              .loanApplications[
                                                                          index]
                                                                      [
                                                                      'profile_pic'],
                                                                )),
                                                          ],
                                                        ),
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
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16.sp),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          'UGX ${NumberFormat.decimalPattern().format(int.parse(loanController.loanApplications[index]['loan_amount']))}/=',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 17.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Payout:',
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
                                                        const Spacer(),
                                                        Text(
                                                          'UGX ${NumberFormat.decimalPattern().format(int.parse(loanController.loanApplications[index]['pay_back']))}/=',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 19.sp),
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
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          'UGX ${NumberFormat.decimalPattern().format(int.parse(loanController.loanApplications[index]['outstanding_balance']))}/=',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 21.sp),
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
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(top: 132.0),
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20.0, sigmaY: 20.0),
                                    child: Container(
                                      height: 80.h,
                                      width: double.infinity,
                                      color: Colors.white12,
                                      child: TabBar(
                                        controller:
                                            dashController.tabController,
                                        onTap: (int page) {
                                          dashController.tabCurrentPage = page;

                                          dashController.tabPageController
                                              .animateToPage(
                                                  dashController.tabCurrentPage,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeIn);
                                        },
                                        tabs: [
                                          Tab(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'All Users',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                                Container(
                                                  width: 30.w,
                                                  height: 30.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: Center(
                                                    child: Text(
                                                      users.users.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Applications',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                                Container(
                                                  width: 30.w,
                                                  height: 30.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: Center(
                                                    child: Text(
                                                      loanController
                                                          .loanApplications
                                                          .length
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
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
                            padding: EdgeInsets.only(
                                top: 24.h, left: 45.w, right: 25.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome to Tuula Admin',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        GetStorage().read('fullNames') == null
                                            ? 'Hello Admin'
                                            : 'Hi, ${GetStorage().read('fullNames')}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19.sp,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ]),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    GetStorage().erase();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage()));
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: SvgPicture.asset(
                                        'assets/images/Logout.svg',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            color: Colors.white12,
                            child: BottomNavigationBar(
                                elevation: 0.0,
                                currentIndex: dashController.currentIndex.value,
                                onTap: dashController.onTapped,
                                backgroundColor: Colors.transparent,
                                items: dashController.navigationBarItems),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ));
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}

class CurrentLoanApplications extends StatefulWidget {
  const CurrentLoanApplications({Key? key, required this.currentApplications})
      : super(key: key);

  final List currentApplications;

  @override
  State<CurrentLoanApplications> createState() =>
      _CurrentLoanApplicationsState();
}

class _CurrentLoanApplicationsState extends State<CurrentLoanApplications> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Current Loan Applications',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18.sp),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoreDetails(
                            title: 'Current Loan Applications',
                            data: widget.currentApplications)));
              },
              label: Text(
                'See All',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 18.sp),
              ),
              icon: const Icon(Icons.arrow_right_alt_rounded),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        widget.currentApplications.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 100.h),
                child: Column(children: <Widget>[
                  Text(
                    'No Data to display',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 19.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Icon(CupertinoIcons.nosign)
                ]),
              )
            : SizedBox(
                height: 210.h,
                child: Swiper(
                  itemCount: widget.currentApplications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.r),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Request By:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 17.sp),
                                ),
                                const Spacer(),
                                Text(
                                    widget.currentApplications[index]
                                        ['full_names'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                        fontSize: 17.sp)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ID:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 17.sp),
                                ),
                                const Spacer(),
                                Text(widget.currentApplications[index]['nin'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                        fontSize: 17.sp)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Referral:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 17.sp)),
                                const Spacer(),
                                Text('NONE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                        fontSize: 17.sp)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Amount:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 17.sp)),
                                const Spacer(),
                                Text(
                                    '${widget.currentApplications[index]['loan_amount']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                        fontSize: 17.sp)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Remittance - ${widget.currentApplications[index]['payment_time']}:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 17.sp)),
                                const Spacer(),
                                Text(
                                    widget.currentApplications[index]
                                        ['payment_mode'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                        fontSize: 17.sp)),
                              ],
                            ),
                            Row(
                              children: [
                                ActionChip(
                                  backgroundColor: Colors.green,
                                  onPressed: () {
                                    Server()
                                        .acceptLoanService(context,
                                            widget.currentApplications[index])
                                        .then((value) {
                                      if (value) {
                                        // widget.currentApplications
                                        //     .removeAt(index);
                                        setState(() {});
                                      }

                                      // Get.back();
                                    });
                                  },
                                  avatar: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: Text('Accept',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 17.sp)),
                                ),
                                const Spacer(),
                                ActionChip(
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    Server()
                                        .declineLoanService(widget
                                            .currentApplications[index]['id'])
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  avatar: const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.white,
                                  ),
                                  label: Text('Decline',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          fontSize: 17.sp)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
      ],
    );
  }
}

class DefaulterSection extends StatelessWidget {
  const DefaulterSection({
    required this.defaulter,
    Key? key,
  }) : super(key: key);

  final List defaulter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Defaulter Section',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18.sp),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoreDetails(
                            title: 'Defaulter Section', data: defaulter)));
              },
              label: Text(
                'See All',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 18.sp),
              ),
              icon: const Icon(Icons.arrow_right_alt_rounded),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        SizedBox(
          height: 180.h,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 17.sp),
                          ),
                          const Spacer(),
                          Text(defaulter[index]['full_names'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                  fontSize: 17.sp)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'ID:',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 17.sp),
                          ),
                          const Spacer(),
                          Text(defaulter[index]['nin'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                  fontSize: 17.sp)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Amount:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp)),
                          const Spacer(),
                          Text(defaulter[index]['outstanding_balance'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                  fontSize: 17.sp)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Remittance:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp)),
                          const Spacer(),
                          Text(defaulter[index]['payment_mode'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                  fontSize: 17.sp)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActionChip(
                            backgroundColor: Colors.blue,
                            onPressed: () {
                              _makePhoneCall(defaulter[index]['phone_number']);
                            },
                            avatar: const Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            label: Text('Contact',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 17.sp)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: defaulter.length,
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await _makePhoneCall(launchUri as String);
  }
}
