import 'package:admin_banja/models/faq_model.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _question = TextEditingController();
  final TextEditingController _answer = TextEditingController();

  var refreshState = false.obs;

  showCreateFAQSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: const Color(0xffE5F2F2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        isDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.w, 15.h),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Stack(
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Add a New FAQ,',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                    10.r,
                                  )),
                                  child: SizedBox(
                                    width: 340.w,
                                    height: 220.h,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.w),
                                      child: Column(
                                        children: [
                                          const Text('Do you wish to close?',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            'You are closing without editing/saving changes. You may have lose changes if you hadn\'t yet saved them',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13.5.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 55.h,
                                                    child: const Center(
                                                        child: Text(
                                                      'NO',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 55.h,
                                                    child: const Center(
                                                        child: Text('YES',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 85.h),
                    child: Stack(
                      children: <Widget>[
                        Text(
                          'This section lets you add a a Frequently Asked Question',
                          style:
                              TextStyle(fontFamily: 'Poppins', fontSize: 17.sp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 65.h),
                          child: Form(
                            key: formKey,
                            child: CupertinoScrollbar(
                              thumbVisibility: true,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    Text(
                                      'What is the question',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: Colors.white),
                                      child: TextFormField(
                                        controller: _question,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            hintText: 'write question here',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'What is the answer?',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: Colors.white),
                                      child: TextFormField(
                                        controller: _answer,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            hintText: 'write short answer here',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 10.w,
                          right: 10.w,
                          child: GestureDetector(
                            onTap: () async {
                              if (_question.value.text.isEmpty ||
                                  _answer.value.text.isEmpty) {
                                CustomOverlay.showToast(
                                    'Fill all fields to continue saving',
                                    Colors.red,
                                    Colors.white);
                              } else {
                                HapticFeedback.lightImpact();
                                CustomOverlay.showLoaderOverlay(duration: 1);
                                var faqData = FAQModel(
                                    question: _question.text,
                                    answer: _answer.text);
                                Server.createFAQ(faqData);
                              }
                            },
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: const Color(0xff007981)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create new FAQ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 18.sp),
                                    ),
                                    //    Spacer(),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
