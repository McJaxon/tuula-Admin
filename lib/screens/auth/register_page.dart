import 'package:admin_banja/constants/styles.dart';
import 'package:admin_banja/controllers/authControllers.dart';
import 'package:admin_banja/models/loan_application_details_model.dart';
import 'package:admin_banja/screens/auth/phone_otp.dart';
import 'package:admin_banja/services/server.dart';
import 'package:admin_banja/utils/form_validators.dart';
import 'package:admin_banja/widgets/headers.dart';
import 'package:admin_banja/widgets/text_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
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

  bool validateAndSave() {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {


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
        TextBox(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          validator: FieldValidator.validateNIN,
          maxLength: 14,
          focusNode: authController.nationalIDFocus,
          textEditingController: authController.nationalID,
          title: 'Enter NIN Number',
          hint: 'eg CM546FDF54534FHS',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          maxLength: 6,
          focusNode: authController.referralIDFocus,
          textEditingController: authController.referralID,
          title: 'Referral ID',
          hint: 'enter referral ID - optional',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          textInputType: TextInputType.phone,
          maxLength: 9,
          validator: FieldValidator.validatePhone,
          focusNode: authController.phoneNumberFocus,
          textEditingController: authController.phoneNumber,
          title: 'Phone Number',
          hint: 'enter phone',
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
          style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins '),
        ),
        SizedBox(
          height: 30.h,
        ),
        TextBox(
          textInputType: TextInputType.text,
          validator: FieldValidator.validateEmail,
          focusNode: authController.emailFocus,
          textEditingController: authController.emailAddress,
          title: 'Email Address',
          hint: 'type in your email address',
        ),
        SizedBox(
          height: 22.h,
        ),
        TextBox(
          isPassword: true,
          textInputType: TextInputType.text,
          validator: FieldValidator.validatePassword,
          focusNode: authController.passwordFocus,
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
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: authController.pageController,
            children: [
              Stack(
                children: <Widget>[
                  AuthPageHeader(
                    heading: LoginTypes.newUser == loginType
                        ? 'REGISTER'
                        : 'WELCOME BACK,\nSIGN IN',
                    trigger: authController.trigger.value,
                  ),
                  Positioned(
                      top: 60.h,
                      right: 5.w,
                      child: IconButton(
                          onPressed: () {
                            authController.showAboutDialog(context);
                          },
                          iconSize: 40.w,
                          icon: const Icon(
                            CupertinoIcons.question_circle_fill,
                            color: Color.fromARGB(173, 44, 205, 217),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(
                        top: authController.trigger.value ? 200.h : 400.h),
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.h),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 64.h,
                                    child: CupertinoButton(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: const Color(0xff007981),
                                      child: Text(
                                        LoginTypes.newUser == loginType
                                            ? 'Register'
                                            : 'Sign in',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 23.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () async {
                                        HapticFeedback.lightImpact();
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus &&
                                            currentFocus.focusedChild != null) {
                                          currentFocus.focusedChild!.unfocus();
                                        }

                                        if (LoginTypes.newUser == loginType) {
                                          if (authController
                                                      .nationalID.text.length ==
                                                  14 &&
                                              authController.phoneNumber.text
                                                      .length ==
                                                  9) {
                                            if (validateAndSave()) {
                                              GetStorage().write(
                                                  'nin',
                                                  authController
                                                      .nationalID.value.text);
                                              //authController.phoneAuth(context);
                                            }
                                          } else {
                                            CustomOverlay.showToast(
                                              'Enter NIN and correct phone number to continue',
                                              Colors.red,
                                              Colors.white,
                                            );
                                          }
                                        } else {
                                          if (authController.emailAddress.text
                                                  .isNotEmpty ||
                                              authController
                                                  .password.text.isNotEmpty) {
                                            if (validateAndSave()) {
                                              var userDetails = EndUserModel(
                                                  emailAddress: authController
                                                      .emailAddress.value.text,
                                                  password: authController
                                                      .password.value.text);

                                              await Server.userLogIn(
                                                  context, userDetails);
                                            }
                                          } else {
                                            CustomOverlay.showToast(
                                                'Fill out email and password to continue',
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
                                      ? 'Already have an account?, sign up'
                                      : 'Don\'t have an account, sign up',
                                  style: textButtonStyle,
                                )),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        )),
                  )
                ],
              ),
              PhoneOTP(
                verificationId: authController.verificationId.value,
                tempPhone: authController.phoneNumber.text,
              )
            ],
          );
        }),
      ),
    );
  }
}
