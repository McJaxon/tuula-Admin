import 'dart:ui';

import 'package:admin_banja/screens/more_detail_dash.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/widgets/loading_indicator.dart';
import 'package:admin_banja/widgets/network_error.dart';
import 'package:admin_banja/widgets/no_record_error.dart';
import 'package:admin_banja/widgets/percentage_card.dart';
import 'package:admin_banja/widgets/side_drawer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/dashboard_controller.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> with TickerProviderStateMixin {
  var dashController = Get.put(DashboardController());

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
        body: SliderDrawer(
            slideDirection: SlideDirection.LEFT_TO_RIGHT,
            appBar: Container(),
            slider: SliderView(),
            sliderOpenSize: 240,
            key: dashController.sliderKey,
            child: GestureDetector(
              onTap: () {
                dashController.sliderKey.currentState?.closeSlider();
              },
              child: Container(
                color: const Color.fromARGB(255, 200, 227, 229),
                child: Stack(children: [
                  PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: dashController.controller,
                    children: [
                      FutureBuilder(
                          future: Server().fetchData(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingData();
                            } else if (snapshot.hasError) {
                              return const NetworkError();
                            } else if (snapshot.data == null) {
                              return const NoRecordError();
                            } else {
                              return CupertinoScrollbar(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 160.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Today: ${DateFormat().format(DateTime.now())}',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 22.sp)),
                                            Text(
                                                'Last Updated: ${DateFormat().format(DateTime.now())}',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16.sp)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.w, top: 50.h),
                                        child: SizedBox(
                                            height: 225.h,
                                            child: Swiper(
                                              itemCount: snapshot
                                                  .data['payload']['loan_stats']
                                                      ['percentages']
                                                  .length,
                                              autoplay: true,
                                              autoplayDelay: 6000,
                                              controller:
                                                  dashController.cardController,
                                              itemWidth: 475.w,
                                              layout: SwiperLayout.STACK,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                dashController.currentCard =
                                                    index + 1;
                                                return PercentageCard(
                                                  dashController:
                                                      dashController,
                                                  index: index,
                                                  snapshot: snapshot,
                                                );
                                              },
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 30.0,
                                              left: 20.w,
                                              right: 20.w),
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
                                                        BorderRadius.circular(
                                                            22.r),
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 44.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  child: BarChart(
                                                    BarChartData(
                                                      barTouchData:
                                                          barTouchData,
                                                      titlesData: dashController
                                                          .titlesEducationData,
                                                      borderData: borderData,
                                                      barGroups: List.from(
                                                          snapshot
                                                              .data['payload'][
                                                                  'yearly_stats']
                                                                  ['2022']
                                                              .map(
                                                        (value) =>
                                                            BarChartGroupData(
                                                          x: snapshot
                                                              .data['payload'][
                                                                  'yearly_stats']
                                                                  ['2022']
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
                                                      //maxY: 750,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CurrentLoanApplications(
                                          currentApplications: snapshot
                                                  .data['payload']
                                              ['pending_loan_applications']),
                                      DefaulterSection(defaulter: snapshot
                                                  .data['payload']
                                              ['pending_loan_applications']),
                                      SizedBox(
                                        height: 170.h,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                      Stack(
                        children: [
                          FutureBuilder(
                              future: Future.wait([
                                Server().fetchUsers(),
                                Server().fetchLoans()
                              ]),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LoadingData();
                                } else if (snapshot.hasError) {
                                  return const NetworkError();
                                } else if (snapshot.data == null) {
                                  return const NoRecordError();
                                } else {
                                  return Stack(children: [
                                    PageView(
                                      controller:
                                          dashController.tabPageController,
                                      onPageChanged: (page) {
                                        dashController.tabController
                                            .animateTo(page.toInt());
                                      },
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.only(
                                              top: 240.h, bottom: 200.h),
                                          itemCount: snapshot
                                              .data[0]['payload'].length,
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                                  snapshot.data[0]
                                                                              [
                                                                              'payload']
                                                                          [
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
                                                                          23.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'NIN:',
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
                                                                      snapshot.data[0]['payload']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'nin'],
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
                                                            const Spacer(),
                                                            CircleAvatar(
                                                                radius: 40.r,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  snapshot.data[0]
                                                                              [
                                                                              'payload']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'profile_pic'],
                                                                )),
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
                                                              snapshot.data[0][
                                                                          'payload']
                                                                      [index]
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
                                                          height: 15.h,
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
                                                              snapshot.data[0][
                                                                          'payload']
                                                                      [index][
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
                                                          height: 15.h,
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
                                                              snapshot.data[0][
                                                                      'payload']
                                                                  [
                                                                  index]['email'],
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
                                                      ]),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        ListView.builder(
                                          padding: EdgeInsets.only(
                                              top: 240.h, bottom: 200.h),
                                          itemCount: snapshot
                                              .data[1]['payload'].length,
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                                  snapshot.data[1]
                                                                              [
                                                                              'payload']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'loan_type'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          20.sp),
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
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              16.sp),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Text(
                                                                      snapshot.data[1]['payload']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'full_names'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              16.sp),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        5.h),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'NIN:',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              16.sp),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Text(
                                                                      snapshot.data[1]['payload']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'nin'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              16.sp),
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
                                                                              [
                                                                              'payload']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'profile_pic'],
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
                                                            const Spacer(),
                                                            Text(
                                                              'UGX ${snapshot.data[1]['payload'][index]['loan_amount']}/=',
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
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              'UGX ${snapshot.data[1]['payload'][index]['pay_back']}/=',
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
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              'UGX ${snapshot.data[1]['payload'][index]['outstanding_balance']}/=',
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
                                filter: ImageFilter.blur(
                                    sigmaX: 20.0, sigmaY: 20.0),
                                child: Container(
                                  height: 60.h,
                                  width: double.infinity,
                                  color: Colors.white12,
                                  child: TabBar(
                                    controller: dashController.tabController,
                                    onTap: (int page) {
                                      dashController.tabCurrentPage = page;

                                      dashController.tabPageController
                                          .animateToPage(
                                              dashController.tabCurrentPage,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn);
                                    },
                                    tabs: const [
                                      Tab(
                                        child: Text(
                                          'All Users',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          'Applications',
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
                            IconButton(
                                icon:const Icon(
                                  Icons.menu,
                                ),
                                onPressed: () {
                                  dashController.sliderKey.currentState
                                      ?.openSlider();
                                }),
                            Text(
                              'Tuula Admin Dash',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // const Spacer(),
                            // if (dashController.currentIndex.value == 0) ...[
                            //   IconButton(
                            //       onPressed: () {},
                            //       icon: const Icon(CupertinoIcons.bell))
                            // ] else ...[
                            //   IconButton(
                            //       onPressed: () {},
                            //       icon: SvgPicture.asset(
                            //           'assets/images/Filter 2.svg'))
                            // ]
                          ]),
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
            )));
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
                              data: widget.currentApplications
                            )));
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
                                        .acceptLoanService(
                                            context,
                                            widget.currentApplications[index]
                                                ['id'])
                                        .then((value) {
                                      Get.back();

                                      print('here');
                                      //setState(() {});
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
                                    ;
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
                              title: 'Defaulter Section',
data: defaulter
                            )));
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
                              _makePhoneCall(defaulter[index]['phone_number']
                              );
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
    await launchUrl(launchUri);
  }
}
