import 'dart:ui';

import 'package:admin_banja/services/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({Key? key, required this.data, required this.title})
      : super(key: key);
  final String title;
  final List data;

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 227, 229),
      body: Stack(children: [
        ListView.builder(
          padding: EdgeInsets.only(top: 160.h, bottom: 200.h),
          itemCount: widget.data.length,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data[index]['full_names'],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 23.sp),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ],
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
                            const Spacer(),
                            Text(
                              widget.data[index]['nin'],
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
                              'Amount:',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp),
                            ),
                            const Spacer(),
                            Text(
                              'UGX ${NumberFormat.decimalPattern().format(int.parse(widget.data[index]['outstanding_balance']))} /=',
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
                                'Remittance - ${widget.data[index]['payment_time']}:',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    fontSize: 18.sp)),
                            const Spacer(),
                            Text(widget.data[index]['payment_mode'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54,
                                    fontSize: 18.sp)),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(),
                        Row(
                          children: [
                            ActionChip(
                              backgroundColor: Colors.green,
                              onPressed: () {
                                Server()
                                    .acceptLoanService(
                                        context, widget.data[index])
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
                                    .declineLoanService(
                                        widget.data[index]['id'])
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
                      ]),
                ),
              ),
            );
          }),
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
