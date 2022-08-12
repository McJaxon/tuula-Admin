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
import 'dart:developer';
import 'dart:convert';
import 'package:admin_banja/constants/strings.dart';
import 'package:admin_banja/controllers/loanDetailControllers.dart';
import 'package:admin_banja/models/faq_model.dart';
import 'package:admin_banja/models/loan_application_details_model.dart';
import 'package:admin_banja/models/position_model.dart';
import 'package:admin_banja/models/profession_model.dart';
import 'package:admin_banja/models/salary_scale_model.dart';
import 'package:admin_banja/models/transaction_type_model.dart';
import 'package:admin_banja/screens/dash.dart';
import 'package:admin_banja/utils/customOverlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nanoid/nanoid.dart';

import '../models/loan_category.dart';

enum Category {
  loanCategories,
  userProfileData,
  dashboard,
}

class Server extends GetxController {
  static final accessToken = GetStorage().read('accessToken');

  ///reimburse payment to loan applicant
  static Future makeCashOut(
      String phoneNumber, String clientNames, String amount) async {
    try {
      CustomOverlay.showLoaderOverlay(duration: 6);
      await Future.delayed(const Duration(seconds: 6));

      CustomOverlay.showToast('Cashing out money', Colors.green, Colors.white);

      HapticFeedback.selectionClick();

      var headersList = {
        'Authorization': 'Bearer FLWSECK-0f90d7751866e70efb1626d8715b6ef1-X',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('https://api.flutterwave.com/v3/transfers');
      var transactionRef = 'txf-' + customAlphabet('1234567890abcdef', 10);

      var body = {
        'account_bank': 'MPS',
        'account_number': phoneNumber,
        'amount': amount,
        'currency': 'UGX',
        "narration": "Payment",
        "reference": transactionRef,
        'beneficiary_name': clientNames,
        "meta": {
          "sender": "Tuula Financial Services",
          "sender_country": "UG",
          "mobile_number": "256702703612"
        }
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      print(json.decode(resBody));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan approved Successfully', Colors.green, Colors.white);
        } else {
          CustomOverlay.showToast(
              json.decode(resBody)['message'], Colors.red, Colors.white);
        }
      } else {
        //Get.back();
        print(res.reasonPhrase);
      }
    } catch (e) {
      CustomOverlay.showToast(
          'Something went wrong, try again later', Colors.red, Colors.white);
    }
    Get.back();
  }

  ///creating user
  static Future createUser(
      EndUserModel userDetailModel, BuildContext comtext) async {
    try {
      CustomOverlay.showLoaderOverlay(duration: 6);
      await Future.delayed(const Duration(seconds: 6));

      CustomOverlay.showToast(
          'Creating your account, please wait', Colors.green, Colors.white);
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/user/register'))
            ..fields.addAll(
              {
                'full_names': userDetailModel.fullNames!,
                'phone_number': '0' + userDetailModel.phoneNumber!,
                'email': userDetailModel.emailAddress!,
                'location': userDetailModel.location!,
                'nin': userDetailModel.nin!,
                "password": userDetailModel.password!,
                "password_confirmation": userDetailModel.passwordConfirm!,
                "profile_pic":
                    'https://firebasestorage.googleapis.com/v0/b/banja22.appspot.com/o/clientBase%2Fman.png?alt=media&token=fa15fd5d-b6ad-4150-9dbd-063d112c79c4',
                "role_id": userDetailModel.roleID.toString()

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
        // reset current app state
        await Get.deleteAll(force: true);
// restart app
        Phoenix.rebirth(Get.context!);
// reset get state
        Get.reset();
        Navigator.pushReplacement(
            comtext, MaterialPageRoute(builder: (context) => Dash()));
        GetStorage().write('isLoggedIn', true);
        GetStorage().write('userHasProfileAlready', true);
        GetStorage().write('accessToken', json.decode(message.body)['token']);
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

        GetStorage()
            .write('roleID', json.decode(message.body)['payload']['role_id']);

        GetStorage()
            .write('roleName', json.decode(message.body)['payload']['name']);
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
        // reset current app state
        await Get.deleteAll(force: true);
// restart app
        Phoenix.rebirth(Get.context!);
// reset get state
        Get.reset();
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

  ///create position method
  static Future createPosition(PositionModel positionDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addPositionUrl)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'name': positionDetails.position!,
          'level': positionDetails.level.toString(),
          'description': positionDetails.description!,
          'slug': positionDetails.position!.toLowerCase(),
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
          'Position added successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///create new loan category method
  static Future createLoanCategory(
      LoanCategoryModel loanCategoryDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addLoanType)
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
          'Loan category successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///create frequently asked question method
  static Future createFAQ(FAQModel faqDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addFAQ)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'question': faqDetails.question!,
          'answer': faqDetails.answer!,
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
          'FAQ added successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///create transaction type method
  static Future createTransactionType(
      TransactionTypeModel transactionTypeDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addTransactionType)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'name': transactionTypeDetails.name!,
          'description': transactionTypeDetails.description!,
        },
      );

    ///clean up data before sending it
    // ignore: avoid_single_cascade_in_expression_statements
    request..fields.removeWhere((key, value) => value == '');
    print(request.fields);

    var response = await request.send();

    final message = await http.Response.fromStream(response);
    debugPrint(message.body);

    if (json.decode(message.body)['success'] == true) {
      CustomOverlay.showToast(
          'Transaction Type added successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///create salary scale method
  static Future createSalaryScale(SalaryScaleModel salaryScaleDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addSalaryScale)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'minimum_income': salaryScaleDetails.minimumIncome!,
          'maximum_income': salaryScaleDetails.minimumIncome!,
          'income_range': salaryScaleDetails.incomeRange!
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
          'Salary Scale added successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///create profession method
  static Future createProfession(ProfessionModel professionDetails) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    var request = http.MultipartRequest('POST', addPositionUrl)
      ..headers.addAll(
        {"Authorization": 'Bearer $accessToken'},
      )
      ..fields.addAll(
        {
          'name': professionDetails.name!,
          'description': professionDetails.description!,
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
          'Profession added successfully!', Colors.green, Colors.white);
      Get.back();
    } else {
      CustomOverlay.showToast('Something went wrong', Colors.red, Colors.white);
      Get.back();
    }

    HapticFeedback.selectionClick();

    return response;
  }

  ///accept loan application method
  Future acceptLoanService(BuildContext context, var loan) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/loan/approve_loan/${loan['id']}');

      var body = {"is_approved": 1};
      var req = http.Request('PUT', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // reset current app state
        await Get.deleteAll(force: true);
// restart app
        Phoenix.rebirth(Get.context!);
// reset get state
        Get.reset();

        if (json.decode(resBody)['success'] == true) {
          // Server.makeCashOut(
          //     loan['phone_number'], loan['full_names'], loan['loan_amount']);
          CustomOverlay.showToast(
              'Loan approved Successfully', Colors.green, Colors.white);

          return true;
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

  ///delete loan category method
  Future deleteLoanCategory(var loanCategoryId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url =
          Uri.parse('$baseUrl/settings/remove_loan_category/$loanCategoryId');

      var req = http.Request('DELETE', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Loan Category deleted Successfully', Colors.green, Colors.white);
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

  ///delete position method
  Future deletePosition(var positionId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/settings/remove_position/$positionId');

      var req = http.Request('DELETE', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // reset current app state
        await Get.deleteAll(force: true);
// restart app
        Phoenix.rebirth(Get.context!);
// reset get state
        Get.reset();
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast(
              'Position deleted Successfully', Colors.green, Colors.white);
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

  ///update loan category data
  static Future updatePosition(
      PositionModel positionDetails, var positionId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/settings/edit_position/$positionId');

      var body = {
        'name': positionDetails.position!,
        'level': positionDetails.level.toString(),
        'description': positionDetails.description!,
        'slug': positionDetails.position!.toLowerCase(),
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

  ///update loan category data
  static Future updateLoanCategory(
      LoanCategoryModel loanCategoryDetails, var loanCategoryId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url =
          Uri.parse('$baseUrl/settings/edit_loan_categories/$loanCategoryId');

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

  ///delete loan category method
  Future deleteTransactionType(var transactionTypeId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          '$baseUrl/settings/remove_transaction_type/$transactionTypeId');

      var req = http.Request('DELETE', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      print(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast('Transaction Type deleted Successfully',
              Colors.green, Colors.white);
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

  ///update loan category data
  static Future updateTransactionType(
      TransactionTypeModel transactionTypeDetails,
      var transactionTypeId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);

    try {
      var headersList = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          '$baseUrl/settings/edit_transaction_type/$transactionTypeId');

      var body = {
        'name': transactionTypeDetails.name!,
        'description': transactionTypeDetails.description!,
      };
      var req = http.Request('PUT', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      print(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (json.decode(resBody)['success'] == true) {
          CustomOverlay.showToast('Transaction Type updated Successfully',
              Colors.green, Colors.white);
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

  ///decline loan application
  Future declineLoanService(var loanId) async {
    CustomOverlay.showLoaderOverlay(duration: 6);
    var loanController = Get.put(LoanController());

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
      print(json.decode(resBody));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // reset current app state
        await Get.deleteAll(force: true);
// restart app
        Phoenix.rebirth(Get.context!);
// reset get state
        Get.reset();

        // loanController.loanApplications.removeAt(loanId);
        print(json.decode(resBody));
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

  static Future fetchData() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', dashboardUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    log(json.decode(message.body).toString());
    return json.decode(message.body)['success']
        ? json.decode(message.body)['payload']
        : [];
  }

  static Future fetchPositions() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', allPositionsUrl);
    //..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body)['payload'];
    }
    return response;
  }

  static fetchLoans() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', allLoansUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    return json.decode(message.body)['success']
        ? json.decode(message.body)['payload']
        : [];
  }

  static Future fetchTransactions() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getTransactionTypes)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchSalaryScales() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getSalaryScale)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchProfessions() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getProfessions)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchUsers() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getUsersUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);

    return json.decode(message.body)['success']
        ? json.decode(message.body)['payload']
        : [];
  }

  static Future fetchAdminUsers() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getAdminUsersUrl)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body)['payload'];
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

  static Future fetchAllFAQs() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest('GET', getFAQs)
      ..headers.addAll({"Authorization": 'Bearer $accessToken'});

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == true) {
      return json.decode(message.body);
    }
    return response;
  }

  static Future fetchTransactionFlv() async {
    HapticFeedback.selectionClick();

    var body = {"from": "2020-01-01", "to": "2020-12-30"};
    var request = http.MultipartRequest(
        'GET', Uri.parse('https://api.flutterwave.com/v3/transactions'))
      ..headers.addAll({
        'Authorization': 'Bearer FLWSECK-0f90d7751866e70efb1626d8715b6ef1-X',
      })
      ..fields.addAll(body);

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == 'success') {
      return json.decode(message.body)['data'];
    }
    return json.decode(message.body)['data'];
  }

  static Future fetchFailedPayments() async {
    HapticFeedback.selectionClick();

    var request = http.MultipartRequest(
        'GET', Uri.parse('https://api.flutterwave.com/v3/transfers'))
      ..headers.addAll({
        'Authorization': 'Bearer FLWSECK-0f90d7751866e70efb1626d8715b6ef1-X',
      });

    var response = await request.send();
    final message = await http.Response.fromStream(response);
    print(json.decode(message.body));
    if (json.decode(message.body)['success'] == 'success') {
      return json.decode(message.body)['data'];
    }
    return json.decode(message.body)['data'];
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
}
