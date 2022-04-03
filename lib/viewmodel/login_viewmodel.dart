import 'dart:convert';

import 'package:SomanyHIL/model/login_data.dart';
import 'package:flutter/cupertino.dart';

import '../rest/eightfolds_retrofit.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class LoginViewModel {
  static Future<dynamic> login(
      BuildContext context, String userName, String password) async {
    try {
      var restClient = await EightFoldsRetrofit().getRetrofitService();
      var result =
          await restClient.login(userName: userName, password: password);
      if (result != null && result is LoginData && result.accessToken != null) {
        await Utils.saveToSharedPraferances(
            EightFoldsRetrofit.ACCESS_TOKEN, result.accessToken);
        await Utils.saveToSharedPraferances(
            Constants.LOGIN_DATA, jsonEncode(result));
        return result;
      }

      return null;
    } catch (error) {
      debugPrint("error :" + error.toString());
      return null;
    }
  }

  static Future<dynamic> secureLogin(BuildContext context) async {
    try {
      var restClient = await EightFoldsRetrofit().getSecureRetrofitService();
      var result = await restClient.secureLogin();
      if (result != null && result is LoginData && result.accessToken != null) {
        await Utils.saveToSharedPraferances(
            EightFoldsRetrofit.ACCESS_TOKEN, result.accessToken);
        await Utils.saveToSharedPraferances(
            Constants.LOGIN_DATA, jsonEncode(result));
        return result;
      }

      return null;
    } catch (error) {
      debugPrint("error :" + error.toString());
      return null;
    }
  }
}
