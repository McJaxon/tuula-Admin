import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PercentageCard extends StatelessWidget {
  const PercentageCard(
      {Key? key,
      required this.dashController,
      required this.index,
      required this.snapshot})
      : super(key: key);

  final dashController, index, snapshot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r), color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: Text(
                    snapshot.data['payload']['loan_stats']['percentages'][index]
                        ['category'],
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 24.sp),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 50.0, left: 0.w, right: 10.w),
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
                                axisLineStyle: const AxisLineStyle(
                                    thicknessUnit: GaugeSizeUnit.factor,
                                    thickness: 0.15),
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      angle: 180,
                                      widget: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data['payload']
                                                    ['loan_stats']
                                                    ['percentages'][index]
                                                    ['value']
                                                .round()
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            ' / 100',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                                pointers: <GaugePointer>[
                                  RangePointer(
                                      value: double.parse(snapshot
                                          .data['payload']['loan_stats']
                                              ['percentages'][index]['value']
                                          .toString()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      enableAnimation: true,
                                      animationDuration: 1200,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      gradient: const SweepGradient(
                                          colors: <Color>[
                                            Color(0xFF6A6EF6),
                                            Color(0xFFDB82F5)
                                          ],
                                          stops: <double>[
                                            0.25,
                                            0.75
                                          ]),
                                      color: Color(0xFF00A8B5),
                                      width: 0.15),
                                ]),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'This chart shows number completion against of loans for the above category against 100%',
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
                  borderRadius: BorderRadius.circular(8.r),
                  color: Color.fromARGB(255, 160, 212, 215),
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Container(
                width: 10.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color.fromARGB(255, 200, 227, 229),
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Container(
                width: 10.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color.fromARGB(255, 200, 227, 229),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
              Text(
                '${dashController.currentCard}/${snapshot.data['payload']['loan_stats']['percentages'].length}',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.sp),
              )
            ],
          ),
        ),
      ],
    );
  }
}
