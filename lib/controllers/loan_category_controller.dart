import 'package:admin_banja/constants/strings.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/loan_category.dart';

class LoanCategory extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _loanType = TextEditingController();
  final TextEditingController _abbreviation = TextEditingController();
  final TextEditingController _interestRate = TextEditingController();
  final TextEditingController _interestType = TextEditingController();
  // ignore: unused_field
  final TextEditingController _term = TextEditingController();
  final TextEditingController _termPeriod = TextEditingController();
  final TextEditingController _minimumAmount = TextEditingController();
  final TextEditingController _maximumAmount = TextEditingController();
  final TextEditingController _description = TextEditingController();

  var refreshState = false.obs;

  Future confirmLoanTypeDelete(BuildContext context, var categoryID) {
    refreshState(false);
    return showDialog(
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
                    Text(deletePrompt,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      deleteLoanWarning,
                      style:
                          TextStyle(fontFamily: 'Poppins', fontSize: 14.5.sp),
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
                              decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  )),
                              child: const Center(
                                  child: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
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
                              Server().deleteLoanCategory(categoryID);
                              Navigator.pop(context);
                              refreshState(true);
                            },
                            child: Container(
                              height: 55.h,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  )),
                              child: const Center(
                                  child: Text('YES',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
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
  }

  Future showEditLoanSheet(BuildContext context, var data) {
    HapticFeedback.lightImpact();
    final loanType = TextEditingController(text: data['loan_type']);
    final abbreviation = TextEditingController(text: data['abbreviation']);
    final description = TextEditingController(text: data['description']);
    final minimumAmount = TextEditingController(text: data['minimum_amount']);
    final maximumAmount = TextEditingController(text: data['maximum_amount']);
    final interestRate = TextEditingController(text: data['interest_rate']);
    final interestType = TextEditingController(text: data['interest_type']);
    final termPeriod = TextEditingController(text: data['term_period']);
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
                        'Edit Loan Category,\nDetails',
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
                                          Text(closePrompt,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            closeWarning,
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
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
                                                    child: const Center(
                                                        child: Text(
                                                      'NO',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
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
                          'This section lets you edit a new loan category/type',
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
                                      'What is the Loan type?',
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
                                        controller: loanType,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Describe name of loan eg Emergency Loan',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is Loan Abbreviation?',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white),
                                      child: TextFormField(
                                        controller: abbreviation,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Write loan type short form eg. EL',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'Briefly describe the loan type',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: Colors.white),
                                      child: TextFormField(
                                        controller: description,
                                        maxLines: 6,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Indicate brief description about loan for users',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the minimum amount?',
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
                                        controller: minimumAmount,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: 'Lowest loan amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is maximum Loan Amount?',
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
                                        controller: maximumAmount,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'highest loan lend out amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the loan period?',
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
                                        controller: termPeriod,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'highest loan lend out amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the interest rate?',
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
                                        controller: interestRate,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'highest loan lend out amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is interest type?',
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
                                        controller: interestType,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'what kind on interest is this eg. Accrual',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 320.h,
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
                              if (loanType.value.text.isEmpty ||
                                  abbreviation.value.text.isEmpty ||
                                  maximumAmount.value.text.isEmpty ||
                                  minimumAmount.value.text.isEmpty ||
                                  interestRate.value.text.isEmpty ||
                                  interestType.text.isEmpty ||
                                  termPeriod.value.text.isEmpty) {
                                CustomOverlay.showToast(
                                    'Fill all fields to continue saving',
                                    Colors.red,
                                    Colors.white);
                              } else {
                                HapticFeedback.lightImpact();
                                CustomOverlay.showLoaderOverlay(duration: 1);

                                var loaCategory = LoanCategoryModel(
                                    loanType: loanType.text,
                                    interestRate: int.parse(interestRate.text),
                                    interestType: interestType.text,
                                    abbreviation: abbreviation.text,
                                    description: description.text,
                                    maxAmount: int.parse(maximumAmount.text),
                                    minAmount: int.parse(minimumAmount.text),
                                    term: 5,
                                    termPeriod: int.parse(termPeriod.text));

                                Server.updateLoanCategory(
                                    loaCategory, data['id']);
                                refreshState(true);
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
                                      'Save Changes',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 18.sp),
                                    ),
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

  showCreateLoanSheet(BuildContext context) {
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
                        'Add a new Loan\nCategory,',
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
                                          Text(closePrompt,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            closeWarning,
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
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
                                                    child: const Center(
                                                        child: Text(
                                                      'NO',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.r,
                                                        )),
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
                          'This section lets you add a new loan category/type',
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
                                      'What is the Loan type?',
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
                                        controller: _loanType,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Describe name of loan eg Emergency Loan',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the Loan Abbreviation?',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white),
                                      child: TextFormField(
                                        controller: _abbreviation,
                                        ////validator: FieldValidator.validateEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Write loan type short form eg. EL',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'Briefly describe the loan type',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.8.sp),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Container(
                                      //height: 80.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: Colors.white),
                                      child: TextFormField(
                                        maxLines: 6,
                                        controller: _description,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Indicate brief description about loan for users',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.h,
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the minimum amount?',
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
                                        controller: _minimumAmount,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: 'Lowest loan amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is maximum Loan Amount?',
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
                                        controller: _maximumAmount,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'highest loan lend out amount',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the loan period?',
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
                                        controller: _termPeriod,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'indicate loan tenure period',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is the interest rate?',
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
                                        controller: _interestRate,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'type in the interest rate the loan attracts',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      'What is interest type?',
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
                                        controller: _interestType,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText:
                                                'what kind on interest is this eg. Accrual',
                                            hintStyle:
                                                TextStyle(fontSize: 17.sp),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 320.h,
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
                              if (_loanType.value.text.isEmpty ||
                                  _abbreviation.value.text.isEmpty ||
                                  _maximumAmount.value.text.isEmpty ||
                                  _minimumAmount.value.text.isEmpty ||
                                  _interestRate.value.text.isEmpty ||
                                  _interestType.text.isEmpty ||
                                  _termPeriod.value.text.isEmpty) {
                                CustomOverlay.showToast(
                                    'Fill all fields to continue saving',
                                    Colors.red,
                                    Colors.white);
                              } else {
                                HapticFeedback.lightImpact();
                                CustomOverlay.showLoaderOverlay(duration: 1);
                                var loaCategory = LoanCategoryModel(
                                    loanType: _loanType.text,
                                    interestRate: int.parse(_interestRate.text),
                                    interestType: _interestType.text,
                                    abbreviation: _abbreviation.text,
                                    description: _description.text,
                                    maxAmount: int.parse(_maximumAmount.text),
                                    minAmount: int.parse(_minimumAmount.text),
                                    term: 5,
                                    termPeriod: int.parse(_termPeriod.text));
                                Server.createLoanCategory(loaCategory);
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
                                      'Create new Category',
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
