import 'dart:ui';

import 'package:admin_banja/services/server.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  var dashData = GetStorage().read('dashData');

  List<BottomNavigationBarItem> navigationBarItems = const [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Dash'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.doc_on_doc), label: 'Sheets')
  ];

  PageController controller = PageController();
  SwiperController cardController = SwiperController();

  var currentIndex = 0;
  var currentCard = 1;

  void onTapped(index) {
    HapticFeedback.lightImpact();
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        controller.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        break;

      case 1:
        controller.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        break;
      default:
    }
  }

  void shuffle() {
    if (currentCard <= 5) {
      setState(() {
        currentCard = cardController.index + 1;
      });
    }
  }

  @override
  void initState() {
    controller.addListener(() {
      if (controller.page == 0) {
        setState(() {
          currentIndex = 0;
        });
      } else {
        setState(() {
          currentIndex = 1;
        });
      }
    });
    super.initState();
  }

  FlTitlesData get titlesEducationData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              // case 0:
              //   return 'JAN';
              // case 1:
              //   return 'FEB';
              // case 2:
              //   return 'MAR';
              // case 3:
              //   return 'APR';
              case 0:
                return 'MAY';
              case 1:
                return 'JUN';
              case 2:
                return 'JUL';
              case 3:
                return 'AUG';
              case 4:
                return 'SEPT';
              case 5:
                return 'OCT';
              case 6:
                return 'NOV';
              case 7:
                return 'DEC';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          margin: 10,
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  List<BarChartGroupData> get barChartData =>
      List.from(dashData['yearly_stats']['2022'].map(
        (value) => BarChartGroupData(
          x: dashData['yearly_stats']['2022'].indexOf(value),
          barRods: [
            BarChartRodData(
                y: double.parse(value['count'].toString()),
                colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 227, 229),
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 170.h),
                      child: SizedBox(
                          height: 225.h,

                          child: Swiper(
                            itemCount:
                                dashData['loan_stats']['percentages'].length,
                            autoplay: true,
                            autoplayDelay: 6000,
                            controller: cardController,
                            itemBuilder: (BuildContext context, int index) {
                              currentCard = index + 1;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(22.r),
                                        color: Colors.white),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            top: 20.0,
                                            left: 20.0,
                                            child: Text(
                                              dashData['loan_stats']
                                                      ['percentages'][index]
                                                  ['category'],
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 24.sp),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 50.0,
                                              left: 0.w,
                                              right: 10.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 200,
                                                  child: SfRadialGauge(
                                                    axes: <RadialAxis>[
                                                      RadialAxis(
                                                          showLabels: false,
                                                          showTicks: false,
                                                          startAngle: 270,
                                                          endAngle: 270,
                                                          radiusFactor: 0.8,
                                                          axisLineStyle:
                                                              const AxisLineStyle(
                                                                  thicknessUnit:
                                                                      GaugeSizeUnit
                                                                          .factor,
                                                                  thickness:
                                                                      0.15),
                                                          annotations: <
                                                              GaugeAnnotation>[
                                                            GaugeAnnotation(
                                                                angle: 180,
                                                                widget: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      dashData['loan_stats']['percentages'][index]
                                                                              [
                                                                              'value']
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            22.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' / 100',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            22.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                          pointers: <
                                                              GaugePointer>[
                                                            RangePointer(
                                                                value: double.parse(
                                                                    dashData['loan_stats']['percentages'][index]['value']
                                                                        .toString()),
                                                                cornerStyle:
                                                                    CornerStyle
                                                                        .bothCurve,
                                                                enableAnimation:
                                                                    true,
                                                                animationDuration:
                                                                    1200,
                                                                sizeUnit:
                                                                    GaugeSizeUnit
                                                                        .factor,
                                                                gradient: const SweepGradient(
                                                                    colors: <Color>[
                                                                      Color(
                                                                          0xFF6A6EF6),
                                                                      Color(
                                                                          0xFFDB82F5)
                                                                    ],
                                                                    stops: <
                                                                        double>[
                                                                      0.25,
                                                                      0.75
                                                                    ]),
                                                                color: Color(
                                                                    0xFF00A8B5),
                                                                width: 0.15),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'This chart shows number completion against of loans for the above category agaisnt 100%',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6.0,
                                    right: 10.w,
                                    left: 0.0,
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        Container(
                                          width: 30.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Color.fromARGB(
                                                255, 160, 212, 215),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Container(
                                          width: 10.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: const Color.fromARGB(
                                                255, 200, 227, 229),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Container(
                                          width: 10.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: const Color.fromARGB(
                                                255, 200, 227, 229),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.w,
                                        ),
                                        Text(
                                          '$currentCard/${dashData['loan_stats']['percentages'].length}',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemWidth: 475.w,
                            layout: SwiperLayout.STACK,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 30.0, left: 20.w, right: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(22.r),
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 44.h, left: 10.w, right: 10.w),
                                child: BarChart(
                                  BarChartData(
                                    barTouchData: barTouchData,
                                    titlesData: titlesEducationData,
                                    borderData: borderData,
                                    barGroups: barChartData,
                                    alignment: BarChartAlignment.spaceAround,
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
                        currentApplications:
                            dashData['pending_loan_applications']),
                    const DefaulterSection(),
                    SizedBox(
                      height: 170.h,
                    ),
                  ],
                ),
              ),
              Stack(children: [
                ListView.builder(
                  padding: EdgeInsets.only(top: 200.h, bottom: 200.h),
                  itemCount: dashData['all_loan_applications'].length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Padding(
                          padding: EdgeInsets.all(26.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dashData['all_loan_applications']
                                              [index]['full_names'],
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 23.sp),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'NIN:',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18.sp),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              dashData['all_loan_applications']
                                                  [index]['nin'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 18.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    CircleAvatar(
                                      radius: 40.r,
                                    ),
                                  ],
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'UGX ${dashData['all_loan_applications'][index]['loan_amount']}/=',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w200,
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
                                      'Date:',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    ),
                                    const Spacer(),
                                    // Text(
                                    //   DateTime.fromMillisecondsSinceEpoch(int.parse(dashData['all_loan_applications'][index]['pay_off_date'])).toString(),
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontFamily: 'Poppins',
                                    //       fontWeight: FontWeight.w200,
                                    //       fontSize: 18.sp),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
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
                                      'Payout:',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'UGX ${dashData['all_loan_applications'][index]['pay_back']}/=',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w200,
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
                                      'Remaining:',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'UGX ${dashData['all_loan_applications'][index]['outstanding_balance']}/=',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w200,
                                          fontSize: 18.sp),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    );
                  }),
                )
              ])
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
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Tuula Admin Dash',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (currentIndex == 0) ...[
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.bell))
                    ] else ...[
                      IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/images/Filter 2.svg'))
                    ]
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
                      currentIndex: currentIndex,
                      onTap: onTapped,
                      backgroundColor: Colors.transparent,
                      items: navigationBarItems),
                ),
              ),
            ),
          )
        ],
      ),
    );
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

class CurrentLoanApplications extends StatelessWidget {
  const CurrentLoanApplications({Key? key, required this.currentApplications})
      : super(key: key);

  final List currentApplications;

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
              onPressed: () {},
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
        currentApplications.isEmpty
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
                  itemCount: currentApplications.length,
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
                                Text(currentApplications[index]['nin'],
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
                                    '${currentApplications[index]['loan_amount']}',
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
                                    'Remittance - ${currentApplications[index]['payment_time']}:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 17.sp)),
                                const Spacer(),
                                Text(currentApplications[index]['payment_mode'],
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
                                    Server().acceptLoanService(
                                        currentApplications[index]['id']);
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
                                    Server().declineLoanService(
                                        currentApplications[index]['id']);
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
    Key? key,
  }) : super(key: key);

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
              onPressed: () {},
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
          height: 210.h,
          child: Swiper(
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
                          Text('CMDNGJDN843EFD',
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
                          Text('CMDNGJDN843EFD',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                  fontSize: 17.sp)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Remittance - Weekly:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp)),
                          const Spacer(),
                          Text('Mobile Money',
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
                            onPressed: () {},
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
            itemCount: 10,
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
      ],
    );
  }
}
