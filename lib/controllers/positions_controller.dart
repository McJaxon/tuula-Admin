import 'package:admin_banja/models/position_model.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PositionsController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _description = TextEditingController();

  List<DropdownMenuItem<int>> levels = const [
    DropdownMenuItem(
      child: Text('0'),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text('1'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('2'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('3'),
      value: 3,
    ),
    DropdownMenuItem(
      child: Text('4'),
      value: 4,
    ),
    DropdownMenuItem(
      child: Text('5'),
      value: 5,
    )
  ];

  var refreshState = false.obs;
  // ignore: prefer_typing_uninitialized_variables
  var selectedLevel;




  confirmPositionsDelete(BuildContext context, var categoryID) {
    refreshState(false);
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
                    const Text('Do you wish to delete?',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'You are deleting this position and this action is not reversible, this information will not be available for other users. Confirm action to delete',
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
                              child: const Center(
                                  child: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(
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
                              Server().deletePosition(categoryID);
                              Navigator.pop(context);
                              refreshState(true);
                            },
                            child: Container(
                              height: 55.h,
                              child: const Center(
                                  child: Text('YES',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(
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
  }

  showEditLoanSheet(BuildContext context, var data) {
    HapticFeedback.lightImpact();
    final name = TextEditingController(text: data['name']);

    final description = TextEditingController(text: data['description']);





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
                        'Edit Loan Position,\nDetails',
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
                                            'You are closing without editing/saving changes. You may have limited access until you finish setting up your profile',
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
                          'This section lets you edit a position',
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
                                      'What is the position title',
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
                                        controller: name,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                            hintText:
                                                'write something like Loan Officer',
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
                                      'What is the position description',
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
                                        controller: description,

                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Write short notes about role/position',
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
                              if (name.value.text.isEmpty ||
                                  description.value.text.isEmpty



                                  ) {
                                CustomOverlay.showToast(
                                    'Fill all fields to continue saving',
                                    Colors.red,
                                    Colors.white);
                              } else {
                                HapticFeedback.lightImpact();
                                CustomOverlay.showLoaderOverlay(duration: 1);

                                var positionData = PositionModel(
                                    position: name.text,



                                    description: description.text,


                                    level: data['id'],
                                    );
                                //print(loaCategory.toMap());
                                Server.updatePosition(
                                    positionData, data['id']);
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




  showCreatePositionSheet(BuildContext context) {
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
                        'Add a New Position,',
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
                          'This section lets you add a new position',
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
                                      'What is the position title',
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
                                        controller: _position,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            hintText:
                                                'write something eg Loan Officer',
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
                                      'What is the position description',
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
                                        controller: _description,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            hintText:
                                                'write short motes about position',
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
                                      'What is the position description',
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
                                      child: DropdownButtonFormField(
                                        items: levels,
                                        onChanged: (value) {
                                          selectedLevel =
                                              int.parse(value.toString());
                                        },
                                        value: selectedLevel,
                                        decoration: InputDecoration(
                                            hintText: 'Pick Position level',
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
                              if (_position.value.text.isEmpty || _position.value.text.isEmpty
                              || selectedLevel == null
                              ) {
                                CustomOverlay.showToast(
                                    'Fill all fields to continue saving',
                                    Colors.red,
                                    Colors.white);
                              } else {
                                HapticFeedback.lightImpact();
                                CustomOverlay.showLoaderOverlay(duration: 1);
                                var positionData = PositionModel(
                                    position: _position.text,
                                    level: selectedLevel,
                                    description: _description.text);
                                Server.createPosition(positionData);
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
                                      'Create new Position',
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
