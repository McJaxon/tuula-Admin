import 'dart:ui';

import 'package:admin_banja/constants/styles.dart';
import 'package:admin_banja/controllers/auth_controllers.dart';
import 'package:admin_banja/models/loan_application_details_model.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/utils/form_validators.dart';
import 'package:admin_banja/widgets/text_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/customOverlay.dart';

enum LoginTypes { newUser, existingUser }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var loginType = LoginTypes.newUser;
  var authController = Get.put(AuthController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PageController sigInInController = PageController();
  var selectedRole;
  bool validateAndSave() {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  List<DropdownMenuItem<Object>> roleList = [];

  @override
  void initState() {
    Server.fetchPositions().then((value) {
      setState(() {
        value.map((e) {
          roleList
              .add(DropdownMenuItem(value: e['id'], child: Text(e['name'])));
        }).toList();
      });
    });

    authController.nationalIDFocus.addListener(() {
      if (authController.nationalIDFocus.hasFocus) {
        authController.trigger(true);
      } else {
        authController.trigger(false);
      }
    });

    authController.referralIDFocus.addListener(() {
      if (authController.referralIDFocus.hasFocus) {
        authController.trigger(true);
      } else {
        authController.trigger(false);
      }
    });

    authController.phoneNumberFocus.addListener(() {
      if (authController.phoneNumberFocus.hasFocus) {
        authController.trigger(true);
      } else {
        authController.trigger(false);
      }
    });

    authController.emailFocus.addListener(() {
      if (authController.emailFocus.hasFocus) {
        authController.trigger(true);
      } else {
        authController.trigger(false);
      }
    });

    authController.passwordFocus.addListener(() {
      if (authController.passwordFocus.hasFocus) {
        authController.trigger(true);
      } else {
        authController.trigger(false);
      }
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    authController.emailAddress.clear();
    authController.password.clear();
    authController.phoneNumber.clear();
    authController.referralID.clear();
    authController.nationalID.clear();
  }

  buildForm() {
    if (LoginTypes.newUser == loginType) {
      return [
        SizedBox(
          height: 30.h,
        ),
        Text(
          'Create Account',
          style: TextStyle(fontSize: 20.sp, fontFamily: 'Poppins '),
        ),
        SizedBox(
          height: 30.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textEditingController: authController.fullName,
          title: 'Enter full names',
          hint: 'write all names eg last and first name',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          validator: FieldValidator.validateEmail,
          textEditingController: authController.emailAddress,
          title: 'Enter email address',
          hint: 'eg user@gmail.com',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          validator: FieldValidator.validateNIN,
          maxLength: 14,
          textEditingController: authController.nationalID,
          title: 'Enter NIN Number',
          hint: 'eg CM546FDF54534FHS',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textEditingController: authController.location,
          title: 'Enter Location',
          hint: 'eg Kampala',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.phone,
          maxLength: 9,
          validator: FieldValidator.validatePhone,
          textEditingController: authController.phoneNumber,
          title: 'Phone Number',
          hint: 'enter phone',
        ),
        SizedBox(
          height: 22.h,
        ),
        Text('Choose Role',
            style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 7.h,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: const Color(0xffF2F2F2)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                items: roleList,
                decoration: InputDecoration(
                    suffixStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                    counterText: '',
                    prefixStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp),
                    hintText: 'Pick Role/Position',
                    hintStyle: TextStyle(
                        fontSize: 15.sp,
                        color: const Color.fromARGB(255, 125, 122, 122)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.w)),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            )),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          isPassword: true,
          textEditingController: authController.password,
          title: 'Password',
          hint: 'create a password',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          isPassword: true,
          textInputType: TextInputType.text,
          textEditingController: authController.passwordConfirm,
          title: 'Confirm Password',
          hint: 're-enter password',
        ),
        SizedBox(
          height: 300.h,
        ),
      ];
    } else {
      return [
        SizedBox(
          height: 30.h,
        ),
        Text(
          'Log in to continue',
          style: TextStyle(fontSize: 15.sp, fontFamily: 'Poppins '),
        ),
        SizedBox(
          height: 30.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          validator: FieldValidator.validateEmail,
          textEditingController: authController.emailAddress,
          title: 'Email Address',
          hint: 'type in your email address',
        ),
        SizedBox(
          height: 5.h,
        ),
        TextBox(
          isPassword: true,
          textInputType: TextInputType.text,
          validator: FieldValidator.validatePassword,
          textEditingController: authController.password,
          title: 'Password',
          hint: 'type password here',
        ),
        SizedBox(
          height: 300.h,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: Scaffold(
          body: Row(
        children: [
          SizedBox(
            width: size.width / 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/auth_bg_2.webp',
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.black54])),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset('assets/images/tuula_logo.png'),
                    const SizedBox(
                      height: 14.0,
                    ),
                    Text(
                      'Financial partner committed your growth',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 17.sp),
                    ),
                    const Spacer(),
                    Text(
                      '© Copyright 2022 Tuula Credit',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14.sp),
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 80.h,
                  left: 30.w,
                  right: 30.w,
                  child: const Text(
                    'Admin Dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 140,
                      right: 140,
                      top: LoginTypes.newUser == loginType ? 160.h : 160.h),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      shrinkWrap: true,
                      children: buildForm(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white10, Colors.white])),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.h, horizontal: 150),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 60.h,
                                        child: CupertinoButton(
                                          borderRadius:
                                              BorderRadius.circular(60.r),
                                          color: const Color(0xff007981),
                                          child: Text(
                                            LoginTypes.newUser == loginType
                                                ? 'Register'
                                                : 'Sign in',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () async {
                                            HapticFeedback.lightImpact();
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus &&
                                                currentFocus.focusedChild !=
                                                    null) {
                                              currentFocus.focusedChild!
                                                  .unfocus();
                                            }
                                            if (LoginTypes.newUser ==
                                                loginType) {
                                              if (authController.emailAddress.text.isNotEmpty ||
                                                  authController.location.value
                                                      .text.isNotEmpty ||
                                                  authController.nationalID
                                                      .value.text.isNotEmpty ||
                                                  authController.fullName.value
                                                      .text.isNotEmpty ||
                                                  selectedRole != null ||
                                                  authController.phoneNumber
                                                      .value.text.isNotEmpty ||
                                                  authController.passwordConfirm
                                                      .value.text.isNotEmpty ||
                                                  authController.emailAddress
                                                      .value.text.isNotEmpty ||
                                                  authController.password.value
                                                      .text.isNotEmpty ||
                                                  authController.password.text
                                                      .isNotEmpty) {
                                                if (validateAndSave()) {
                                                  var userDetails = EndUserModel(
                                                      location: authController
                                                          .location.value.text,
                                                      nin: authController
                                                          .nationalID
                                                          .value
                                                          .text,
                                                      fullNames: authController
                                                          .fullName.value.text,
                                                      roleID: selectedRole,
                                                      phoneNumber:
                                                          authController
                                                              .phoneNumber
                                                              .value
                                                              .text,
                                                      passwordConfirm:
                                                          authController
                                                              .passwordConfirm
                                                              .value
                                                              .text,
                                                      emailAddress:
                                                          authController
                                                              .emailAddress
                                                              .value
                                                              .text,
                                                      password: authController
                                                          .password.value.text);

                                                  await Server.createUser(
                                                      userDetails, context);
                                                }
                                              } else {
                                                CustomOverlay.showToast(
                                                    'Fill out all fields to continue',
                                                    Colors.red[300]!,
                                                    Colors.white);
                                              }
                                            } else {
                                              if (authController.emailAddress
                                                      .text.isNotEmpty ||
                                                  authController.password.text
                                                      .isNotEmpty) {
                                                if (validateAndSave()) {
                                                  var loginDetails =
                                                      EndUserModel(
                                                          emailAddress:
                                                              authController
                                                                  .emailAddress
                                                                  .value
                                                                  .text,
                                                          password:
                                                              authController
                                                                  .password
                                                                  .value
                                                                  .text);

                                                  await Server.userLogIn(
                                                      context, loginDetails);
                                                }
                                              } else {
                                                CustomOverlay.showToast(
                                                    'Fill email and password to continue',
                                                    Colors.red,
                                                    Colors.white);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (LoginTypes.newUser == loginType) {
                                        loginType = LoginTypes.existingUser;
                                      } else {
                                        loginType = LoginTypes.newUser;
                                      }
                                    });
                                  },
                                  child: Text(
                                    LoginTypes.newUser == loginType
                                        ? 'Already have an account?, log in'
                                        : 'Don\'t have an account, sign up',
                                    style: textButtonStyle,
                                  )),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
