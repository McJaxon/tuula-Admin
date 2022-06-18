import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 227, 229),
      body: Stack(children: [
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
                      icon: Icon(
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
