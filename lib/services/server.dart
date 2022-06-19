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
import 'package:admin_banja/constants/strings.dart';
import 'package:admin_banja/controllers/loanDetailControllers.dart';
import 'package:admin_banja/models/loan_application_details_model.dart';
import 'package:admin_banja/screens/dash.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/loan_category.dart';

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
        GetStorage()
            .write('userID', json.decode(message.body)['payload']['id']);
        GetStorage().write(
            'fullNames', json.decode(message.body)['payload']['full_names']);
        GetStorage().write(
            'emailAddress', json.decode(message.body)['payload']['email']);
        GetStorage().write(
            'profilePic', json.decode(message.body)['payload']['profile_pic']);
        GetStorage().write('nin', json.decode(message.body)['payload']['nin']);
        GetStorage().write(
            'location', json.decode(message.body)['payload']['location']);
        GetStorage().write('phoneNumber',
            json.decode(message.body)['payload']['phone_number']);
        CustomOverlay.showToast(
            'Hey there!, welcome back😊', Colors.green, Colors.white);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Dash()));
      } else {
        CustomOverlay.showToast(
            json.decode(message.body)['message'], Colors.red, Colors.white);
      }
    } catch (e) {
      print(e);
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

  ///synchronize loan application record with the server
  static Future createLoanCategory(
      LoanCategoryModel loanCategoryDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', postLoanType)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'loan_type': loanCategoryDetails.loanType!,
          'interest_type': loanCategoryDetails.interestType!,
          'interest_rate': loanCategoryDetails.interestRate.toString(),
          'term': loanCategoryDetails.term.toString(),
          'term_period': loanCategoryDetails.termPeriod.toString(),
          'minimum_amount': loanCategoryDetails.minAmount.toString(),
          'maximum_amount': loanCategoryDetails.maxAmount.toString(),
          'abbreviation': loanCategoryDetails.abbreviation!,
          'description': loanCategoryDetails.description!,
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
          'Loan category successful!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  Future acceptLoanService(BuildContext context, var loanId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
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
        Get.back();
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan approved Successfully', Colors.green, Colors.white);
        } else {
          CustomOverlay.showToast(
              json.decode(resBody)['message'], Colors.red, Colors.white);
        }
      } else {
        Get.back();
        print(res.reasonPhrase);
      }

      HapticFeedback.selectionClick();
    } catch (e) {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }
  }

  Future deleteLoanCategory(var loanCategoryId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/loan/remove_loan_category/$loanCategoryId');

      var req = http.Request('DELETE', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan Categroy deleted Successfully', Colors.green, Colors.white);
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

  static Future updateLoanCategory(
      LoanCategoryModel loanCategoryDetails, var loanCategoryId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/loan/edit_loan_categories/$loanCategoryId');

      var body = {
        'loan_type': loanCategoryDetails.loanType!,
        'interest_type': loanCategoryDetails.interestType!,
        'interest_rate': loanCategoryDetails.interestRate.toString(),
        'term': loanCategoryDetails.term.toString(),
        'term_period': loanCategoryDetails.termPeriod.toString(),
        'minimum_amount': loanCategoryDetails.minAmount.toString(),
        'maximum_amount': loanCategoryDetails.maxAmount.toString(),
        'abbreviation': loanCategoryDetails.abbreviation!,
        'description': loanCategoryDetails.description!,
      };
      var req = http.Request('PUT', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan Category updated Successfully', Colors.green, Colors.white);
          Get.back();
        } else {
          CustomOverlay.showToast(
              json.decode(resBody)['message'], Colors.red, Colors.white);
          Get.back();
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
        'Authorization': 'Bearer $accessToken',
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
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', dashboardUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  Future fetchLoans() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', allLoansUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  Future fetchUsers() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getUsersUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchAllPayments() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getAllPayments)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchAllLoanCategories() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getAllLoanTypes)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static dashUpdate(var obj) async {
    {
      GetStorage().write('dashData', obj);

      // preference.setString('dashboardJson', obj);
    }
  }
}
