//  DISABILITY INFORMATION MANAGEMENT SYSTEM - DMIS
//
//  Created by Ronnie Zad.
//  2021, Centric Solutions-UG. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:admin_banja/constants/strings.dart';
import 'package:admin_banja/controllers/loanDetailControllers.dart';
import 'package:admin_banja/models/loan_application_details_model.dart';
import 'package:admin_banja/services/local_db.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

enum Category {
  loanCategories,
  userProfileData,
  dashboard,
}

class Server extends GetxController {
  static final accessToken = GetStorage().read('accessToken');

  ///creating user
  static Future createUser(EndUserModel userDetailModel) async {
    try {
      CustomOverlay.showLoaderOverlay(duration: 6);
      await Future.delayed(const Duration(seconds: 6));

      CustomOverlay.showToast(
          'Creating your account, please wait', Colors.green, Colors.white);
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/user/register'))
            ..files.add(
              await http.MultipartFile.fromPath(
                'profile_pic',
                userDetailModel.profilePic!,
              ),
            )
            ..fields.addAll(
              {
                'full_names': userDetailModel.fullNames!,
                'phone_number': userDetailModel.phoneNumber!,
                'email': userDetailModel.emailAddress!,
                'location': userDetailModel.location!,
                'nin': userDetailModel.nin!,
                "password": userDetailModel.password!,
                "password_confirmation": userDetailModel.passwordConfirm!,

                //'referral_id': element['referral_id'],
                //'sex': element['sex'],
              },
            );

      ///clean up data before sending it
      // ignore: avoid_single_cascade_in_expression_statements
      request..fields.removeWhere((key, value) => value == '');

      var response = await request.send();

      final message = await http.Response.fromStream(response);

      HapticFeedback.selectionClick();

      debugPrint(message.body);
      debugPrint('${response.statusCode}');

      if (json.decode(message.body)['success'] == true) {
        GetStorage().write('userHasProfileAlready', true);
        GetStorage().write('accessToken', json.decode(message.body)['token']);
        GetStorage().write('userID', json.decode(message.body)['user']['id']);
        GetStorage().write(
            'fullNames', json.decode(message.body)['user']['full_names']);
        GetStorage()
            .write('emailAddress', json.decode(message.body)['user']['email']);
        GetStorage().write(
            'profilePic', json.decode(message.body)['user']['profile_pic']);
        GetStorage().write('nin', json.decode(message.body)['user']['nin']);
        GetStorage()
            .write('location', json.decode(message.body)['user']['location']);
        GetStorage().write(
            'phoneNumber', json.decode(message.body)['user']['phone_number']);
        CustomOverlay.showToast(
            'Account created successfully!', Colors.green, Colors.white);
      } else {
        CustomOverlay.showToast(
            'Something went wrong, try again later', Colors.red, Colors.white);
      }
    } catch (e) {
      CustomOverlay.showToast(
          'Something went wrong, try again later', Colors.red, Colors.white);
    }
  }

  ///user login
  static Future userLogIn(
      BuildContext context, EndUserModel userDetailModel) async {
    CustomOverlay.showLoaderOverlay(duration: 6);
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/user/login'))
            ..fields.addAll(
              {
                'email': userDetailModel.emailAddress!,
                'password': userDetailModel.password!,
              },
            );

      ///clean up data before sending it
      // ignore: avoid_single_cascade_in_expression_statements
      request..fields.removeWhere((key, value) => value == '');

      var response = await request.send();

      final message = await http.Response.fromStream(response);

      HapticFeedback.selectionClick();

      debugPrint(message.body);
      debugPrint('${response.statusCode}');

      if (json.decode(message.body)['success'] == true) {
        GetStorage().write('isLoggedIn', true);
        GetStorage().write('userHasProfileAlready', true);
        GetStorage()
            .write('accessToken', json.decode(message.body)['access_token']);
        GetStorage().write('userID', json.decode(message.body)['user']['id']);
        GetStorage().write(
            'fullNames', json.decode(message.body)['user']['full_names']);
        GetStorage()
            .write('emailAddress', json.decode(message.body)['user']['email']);
        GetStorage().write(
            'profilePic', json.decode(message.body)['user']['profile_pic']);
        GetStorage().write('nin', json.decode(message.body)['user']['nin']);
        GetStorage()
            .write('location', json.decode(message.body)['user']['location']);
        GetStorage().write(
            'phoneNumber', json.decode(message.body)['user']['phone_number']);
        CustomOverlay.showToast(
            'Hey there!, welcome back😊', Colors.green, Colors.white);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        CustomOverlay.showToast(
            json.decode(message.body)['message'], Colors.red, Colors.white);
      }
    } catch (e) {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
    }
  }

  ///synchronize loan application record with the server
  static Future syncLoanApplication(
      LoanApplicationModel loanApplicationDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);
    final loanController = Get.put(LoanDetailController());
    //Future userDetails = LocalDB.getUserDetails();

    //var userDetailsBody = await userDetails;

    //List<Map<String, dynamic>> raw = userDetailsBody;

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/loan/new_loan_application'))
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'loan_type': loanApplicationDetails.loanType,
          'loan_id': loanApplicationDetails.loanID,
          'user_id': GetStorage().read('userID').toString(),
          'loan_amount': loanApplicationDetails.loanAmount.toString(),
          'tenure_period': loanApplicationDetails.tenurePeriod.toString(),
          'payment_frequency':
              loanApplicationDetails.paymentFrequency.toString(),
          'interest_rate': loanApplicationDetails.interestRate.toString(),
          'transaction_source': loanApplicationDetails.transactionSource,
          'principal': loanApplicationDetails.principal.toString(),
          'interest': loanApplicationDetails.interest.toString(),
          'outstanding_balance':
              loanApplicationDetails.outstandingBalance.toString(),
          'pay_off_date': loanApplicationDetails.payOffDate.toString(),
          'payment_mode': loanApplicationDetails.paymentMode,
          'payment_time': loanApplicationDetails.paymentTime,
          'loan_period': loanApplicationDetails.loanPeriod,
          'pay_back': loanApplicationDetails.payBack.toString(),
          'is_cleared': loanApplicationDetails.isCleared ? '1' : '0',
          'approved_status': loanApplicationDetails.approvedStatus ? '1' : '0',
        },
      );

    ///clean up data before sending it
    // ignore: avoid_single_cascade_in_expression_statements
    request..fields.removeWhere((key, value) => value == '');

    var response = await request.send();

    final message = await http.Response.fromStream(response);
    debugPrint(message.body);

    if (json.decode(message.body)['success'] == true) {
      CustomOverlay.showToast(
          'Loan application successful!', Colors.green, Colors.white);
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
    }

    HapticFeedback.selectionClick();

    return response;
  }

  static Future uploadData(BuildContext context) async {
    try {
      Future userDetails = LocalDB.getUserDetails();
      Future loanApplicationDetails = LocalDB.getLoanDetails();

      var userDetailsBody = await userDetails;
      var loanApplicationDetailsBody = await loanApplicationDetails;

      int userDetailsBodyListLength = userDetailsBody.length;
      int loanApplicationDetailsListLength = loanApplicationDetailsBody.length;

      showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              elevation: 24.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 20.w,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 22.w,
                      right: 22.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Syncing app data',
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SvgPicture.asset('assets/images/sync.svg',
                            color: Colors.black),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16.w, right: 16.w, top: 16.h),
                          child: Text(
                            'We are syncing your app data with the server. This might take a while depending on your internet connection, please wait.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: 220.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: LinearProgressIndicator(
                                minHeight: 10.h,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue)),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text('Please wait...!',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        SizedBox(height: 35.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Record Type',
                              //       Factor: 0.7,
                              //       style: appSettingsBody2,
                              //     ),
                              //     Spacer(),
                              //     Text(
                              //       'Capacity',
                              //       Factor: 0.7,
                              //       style: appSettingsBody2,
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 6.h),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'PWD records',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //     Spacer(),
                              //     Text(
                              //       '$pwdListLength',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //   ],
                              // ),

                              // Row(
                              //   children: [
                              //     Text(
                              //       'Group Application records',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //     Spacer(),
                              //     Text(
                              //       '$groupApplicationsLength',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Approved National Appraisals',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //     Spacer(),
                              //     Text(
                              //       '$fieldVerifyLength',
                              //       Factor: 0.7,
                              //       style: appSettingsBody,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      var responses = await Future.wait(
        [],
      );

      if (loanApplicationDetailsListLength != 0 ||
          userDetailsBodyListLength != 0) {
        // return [
        //   _getResultFromResponse(
        //       responses[0], context, Category.userProfileData),
        //   _getResultFromResponse(responses[1], context, Category.loanCategories)
        // ];
      } else {
        return [
          Navigator.pop(context),
          await Future.delayed(const Duration(seconds: 1)),
          HapticFeedback.selectionClick(),
          CustomOverlay.showToast(
              'Your data is already up to date', Colors.lightBlue, Colors.white)
        ];
      }
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      HapticFeedback.selectionClick();
      CustomOverlay.showToast(
          'Your phone does not have a healthy internet connection, Try again later!',
          Colors.orange.shade400,
          Colors.white);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
      print('CAUGHT ERROR HERE : ' + e.toString());
    }
  }

  static _getResultFromResponse(
      http.StreamedResponse response, BuildContext context, category) async {
    final message = await http.Response.fromStream(response);

    HapticFeedback.selectionClick();

    debugPrint(message.body);
    debugPrint(json.decode(message.body));
    debugPrint('${response.statusCode}');

    if (json.decode(message.body)['success'] == true) {
      switch (category) {
        case Category.loanCategories:
          {
            LocalDB.updateLoanApplication();
          }
          break;
        case Category.userProfileData:
          {
            LocalDB.updateUseRecord();
          }
          break;

        default:
          {
            debugPrint("Invalid choice");
          }
          break;
      }
    }

    if (json.decode(message.body)['error_code'] == 'SERVER_ERROR') {
      return [
        Navigator.pop(context),
        await Future.delayed(const Duration(seconds: 2)),
        CustomOverlay.showToast(
            'Something went wrong, please talk to your system admin',
            Colors.red.shade400,
            Colors.white)
      ];
    } else if (json.decode(message.body)['error_code'] ==
        'UNAUTHORIZED_ACCESS') {
      return [
        Navigator.pop(context),
        await Future.delayed(const Duration(seconds: 2)),
        CustomOverlay.showToast(
            'You are not authorized to perform this action, please contact your system admin',
            Colors.red.shade200,
            Colors.white)
      ];
    } else if (response.statusCode != 200) {
      return [
        Navigator.pop(context),
        await Future.delayed(const Duration(seconds: 2)),
        CustomOverlay.showToast(
            'Something went wrong, please talk to your system admin',
            Colors.red.shade400,
            Colors.white)
      ];
    }
  }

  Future acceptLoanService(var loanId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzE2ZmU4ZjdmNTNjODExOWMzZGIxNTRmMGQwMDhhNDRmMThhYmE1OTg3YTI3MjMyMzdhZTEwMWQxNjJjYTI5OTk5MGJjM2JmZDFhY2RlZDgiLCJpYXQiOjE2NTM2NTg2MjYuMTcxNjk5LCJuYmYiOjE2NTM2NTg2MjYuMTcxNywiZXhwIjoxNjg1MTk0NjI2LjE2OTU2OCwic3ViIjoiMSIsInNjb3BlcyI6W119.SxaKTZncFibtv43h7_hElas1pLkSms_vqVA224kuRyjUesdUezF4L8NuekbnDN9ytjZoIMllsZStJZVt7n42_sIwSa3HXqsVILRhVsHHtsS5FDeKlEbUMnz_2Vpo6l72NKmmkkNMjmm37t49xTFb1pPY9SsKOJmb0dhHPqBRWGn0DF_AjzuPspqnlcAgGIr7HYcG78-udaTFutqcjtL4C-xDH-lO6YYMpqLijkerpfbCsOdEg6IGcuhdS4BixcDKAgzwTrp7JtanbOZp9qzxnDtIYvY7bkpt3vDrenabuGenM48UL7CnJNYKRQN_vCqTOXa_cTRpDVY69he2g2UUwP_h3LHNTaac7JAniPtfg_XEmzNY__d1yZ21we-KKiheSEeZhXefX8PCYGR_ZFTp2Ro0zFMQPGOWku_puabM3xgG0fCR-nGSfnsHHKxpuHLjlZhOEIk6GLY1u2cHzOPfS5T7r9pBTWBBY5nsKZId7BfzSQ-1btD0Y8Nf7hC4FmakcH3J3bWbpUgxj427poZrtyAoQ2amzkELFCLNSZ00wT9FNy9X4VVXb4tGYSuEW-ZC0NJ7M8BoM22OQzkt2r__WDAGFGcxMkXag80o4lEHNih7lZXUgWC6YWE261GfwR4mhem6HA9_pWd6cqbNTqpsrl6ly4Cv45-l8hklf9DVOec',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/loan/approve_loan/$loanId');

      var body = {"is_approved": 1};
      var req = http.Request('PUT', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan approved Successfully', Colors.green, Colors.white);
        } else {
          CustomOverlay.showToast(
              json.decode(resBody)['message'], Colors.red, Colors.white);
        }
      } else {
        print(res.reasonPhrase);
      }

      HapticFeedback.selectionClick();
    } catch (e) {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
    }
  }

  Future declineLoanService(var loanId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzE2ZmU4ZjdmNTNjODExOWMzZGIxNTRmMGQwMDhhNDRmMThhYmE1OTg3YTI3MjMyMzdhZTEwMWQxNjJjYTI5OTk5MGJjM2JmZDFhY2RlZDgiLCJpYXQiOjE2NTM2NTg2MjYuMTcxNjk5LCJuYmYiOjE2NTM2NTg2MjYuMTcxNywiZXhwIjoxNjg1MTk0NjI2LjE2OTU2OCwic3ViIjoiMSIsInNjb3BlcyI6W119.SxaKTZncFibtv43h7_hElas1pLkSms_vqVA224kuRyjUesdUezF4L8NuekbnDN9ytjZoIMllsZStJZVt7n42_sIwSa3HXqsVILRhVsHHtsS5FDeKlEbUMnz_2Vpo6l72NKmmkkNMjmm37t49xTFb1pPY9SsKOJmb0dhHPqBRWGn0DF_AjzuPspqnlcAgGIr7HYcG78-udaTFutqcjtL4C-xDH-lO6YYMpqLijkerpfbCsOdEg6IGcuhdS4BixcDKAgzwTrp7JtanbOZp9qzxnDtIYvY7bkpt3vDrenabuGenM48UL7CnJNYKRQN_vCqTOXa_cTRpDVY69he2g2UUwP_h3LHNTaac7JAniPtfg_XEmzNY__d1yZ21we-KKiheSEeZhXefX8PCYGR_ZFTp2Ro0zFMQPGOWku_puabM3xgG0fCR-nGSfnsHHKxpuHLjlZhOEIk6GLY1u2cHzOPfS5T7r9pBTWBBY5nsKZId7BfzSQ-1btD0Y8Nf7hC4FmakcH3J3bWbpUgxj427poZrtyAoQ2amzkELFCLNSZ00wT9FNy9X4VVXb4tGYSuEW-ZC0NJ7M8BoM22OQzkt2r__WDAGFGcxMkXag80o4lEHNih7lZXUgWC6YWE261GfwR4mhem6HA9_pWd6cqbNTqpsrl6ly4Cv45-l8hklf9DVOec',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/loan/decline_loan/$loanId');

      var body = {"is_denied": 1};
      var req = http.Request('PUT', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan declined Successfully', Colors.green, Colors.white);
        } else {
          CustomOverlay.showToast(
              json.decode(resBody)['message'], Colors.red, Colors.white);
        }
      } else {
        print(res.reasonPhrase);
      }

      HapticFeedback.selectionClick();
    } catch (e) {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
    }
  }

  Future fetchData() async {
    var responses = await Future.wait([
      //get dashboard data
      http.get(dashboardUrl, headers: {
        "Authorization":
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzE2ZmU4ZjdmNTNjODExOWMzZGIxNTRmMGQwMDhhNDRmMThhYmE1OTg3YTI3MjMyMzdhZTEwMWQxNjJjYTI5OTk5MGJjM2JmZDFhY2RlZDgiLCJpYXQiOjE2NTM2NTg2MjYuMTcxNjk5LCJuYmYiOjE2NTM2NTg2MjYuMTcxNywiZXhwIjoxNjg1MTk0NjI2LjE2OTU2OCwic3ViIjoiMSIsInNjb3BlcyI6W119.SxaKTZncFibtv43h7_hElas1pLkSms_vqVA224kuRyjUesdUezF4L8NuekbnDN9ytjZoIMllsZStJZVt7n42_sIwSa3HXqsVILRhVsHHtsS5FDeKlEbUMnz_2Vpo6l72NKmmkkNMjmm37t49xTFb1pPY9SsKOJmb0dhHPqBRWGn0DF_AjzuPspqnlcAgGIr7HYcG78-udaTFutqcjtL4C-xDH-lO6YYMpqLijkerpfbCsOdEg6IGcuhdS4BixcDKAgzwTrp7JtanbOZp9qzxnDtIYvY7bkpt3vDrenabuGenM48UL7CnJNYKRQN_vCqTOXa_cTRpDVY69he2g2UUwP_h3LHNTaac7JAniPtfg_XEmzNY__d1yZ21we-KKiheSEeZhXefX8PCYGR_ZFTp2Ro0zFMQPGOWku_puabM3xgG0fCR-nGSfnsHHKxpuHLjlZhOEIk6GLY1u2cHzOPfS5T7r9pBTWBBY5nsKZId7BfzSQ-1btD0Y8Nf7hC4FmakcH3J3bWbpUgxj427poZrtyAoQ2amzkELFCLNSZ00wT9FNy9X4VVXb4tGYSuEW-ZC0NJ7M8BoM22OQzkt2r__WDAGFGcxMkXag80o4lEHNih7lZXUgWC6YWE261GfwR4mhem6HA9_pWd6cqbNTqpsrl6ly4Cv45-l8hklf9DVOec'
      }),

      //get user details
      //http.get(getUser, headers: {"Authorization": 'Bearer $accessToken'}),
    ]);

    return [
      ..._getDashData(responses[0]),
    ];
  }

  static _getDashData(http.Response response) {
    
    return [
      if (response.statusCode == 200)
        if (json.decode(response.body)['success'])
          dashUpdate(json.decode(response.body)['payload'])
    ];
  }

  static dashUpdate(var obj) async {
    {
      //GetStorage().write('dashDat', obj);
      print(obj);
      // preference.setString('dashboardJson', obj);
    }
  }

  // static _getVillageFromResponse(context, http.Response response) {
  //   List villages = [];

  //   return [
  //     if (response.statusCode == 200)
  //       {
  //         if (json.decode(response.body)['success'])
  //           {
  //             for (var i in json.decode(response.body)['payload'])
  //               {villages.add(i)},
  //             LocalDB.writeAdministrationVillageData(villages)
  //           }
  //       }
  //   ];
  // }

  // static dataFill(BuildContext context, var select, var obj) async {
  //   SharedPreferences preference = await SharedPreferences.getInstance();

  //   switch (select) {
  //     case Repository.dashboard:
  //       {
  //         preference.setString('dashboardJson', json.encode(obj));
  //       }

  //       break;

  //     case Repository.districts:
  //       {
  //         LocalDB.writeAdministrationDistrictData(obj);
  //       }
  //       break;

  //     case Repository.counties:
  //       {
  //         LocalDB.writeAdministrationCountyData(obj);
  //       }
  //       break;

  //     case Repository.subcounties:
  //       {
  //         LocalDB.writeAdministrationSubCountyData(obj);
  //       }
  //       break;

  //     case Repository.parish:
  //       {
  //         LocalDB.writeAdministrationParishData(obj);
  //       }
  //       break;

  //     case Repository.village:
  //       {
  //         LocalDB.writeAdministrationVillageData(obj);
  //       }
  //       break;

  //     case Repository.banks:
  //       {
  //         LocalDB.writeBankData(obj);
  //       }
  //       break;

  //     case Repository.committeeroles:
  //       {
  //         LocalDB.writeCommitteeRolesData(obj);
  //       }
  //       break;

  //     case Repository.disabilities:
  //       {
  //         LocalDB.writeDisabilitiesData(obj);
  //       }
  //       break;

  //     case Repository.disabilitycauses:
  //       {
  //         LocalDB.writeDisabilityCausesData(obj);
  //       }
  //       break;

  //     case Repository.disabilityseverities:
  //       {
  //         LocalDB.writeDisabilitySeverityData(obj);
  //       }
  //       break;

  //     case Repository.disabilityguiding:
  //       {
  //         LocalDB.writeDisabilityGuidingQuestionsData(obj);
  //       }
  //       break;

  //     case Repository.grouproles:
  //       {
  //         LocalDB.writeGroupRolesData(obj);
  //       }
  //       break;

  //     case Repository.fiancialyears:
  //       {
  //         LocalDB.writeFinancialYearData(obj);
  //       }
  //       break;

  //     case Repository.quarters:
  //       {
  //         LocalDB.writeFinancialYearQuarterData(obj);
  //       }
  //       break;

  //     case Repository.unitmeasures:
  //       {
  //         LocalDB.writeUnitMeasuresData(obj);
  //       }
  //       break;

  //     case Repository.supportrequired:
  //       {
  //         LocalDB.writeSupportRequiredData(obj);
  //       }
  //       break;

  //     ///added service received category
  //     case Repository.servicesreceivedCategory:
  //       {
  //         LocalDB.writePWDServicesCategoryData(obj);
  //       }
  //       break;

  //     ///added service received
  //     case Repository.servicesreceived:
  //       {
  //         LocalDB.writePWDServicesData(obj);
  //       }
  //       break;

  //     case Repository.educationlevels:
  //       {
  //         LocalDB.writeEducationalLevelData(obj);
  //       }
  //       break;

  //     case Repository.educationcertificates:
  //       {
  //         LocalDB.writeEducationalCertificatesData(obj);
  //       }
  //       break;
  //     case Repository.projectindustries:
  //       {
  //         LocalDB.writeProjectIndustriesData(obj);
  //       }
  //       break;

  //     case Repository.positions:
  //       {
  //         LocalDB.writePositionsData(obj);
  //       }
  //       break;

  //     case Repository.pwds:
  //       {
  //         var data = NewPWDModel.fromJson(obj);
  //         LocalDB.writeNewPWDS(data.toMap());
  //       }
  //       break;

  //     case Repository.groups:
  //       {
  //         var data = NewGroupModel.fromJson(obj);
  //         LocalDB.writeNewGroups(data.toMap());
  //       }
  //       break;

  //     default:
  //       {
  //         print("Invalid choice");
  //       }
  //       break;
  //   }
  // }
}
