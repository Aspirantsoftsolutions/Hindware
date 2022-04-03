import 'package:SomanyHIL/model/common_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../rest/eightfolds_retrofit.dart';
import '../screens/splash_screen.dart';
import '../utils/ui_utils.dart';

class BaseViewModel {
  static CommonResponse handelMyError(BuildContext context, Exception onError) {
    switch (onError.runtimeType) {
      case DioError:
        {
          // Here's the sample to get the failed response error code and message
          final data = (onError as DioError).response.data;
          if (data != null) {
            debugPrint('Response Error: ${data.toString()}');
            try {
              var commonResponse = CommonResponse.fromJson(data);
              if (commonResponse.code == 401) {
                // AuthService().logOutUser(context);
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashScreen.routeName, (Route<dynamic> route) => false);
                });
              }
              if (commonResponse.code == 4101 ||
                  commonResponse.code == 4102 ||
                  commonResponse.code == 4103 ||
                  commonResponse.code == 4104 ||
                  commonResponse.code == 4105 ||
                  commonResponse.code == 4106 ||
                  commonResponse.code == 4107 ||
                  commonResponse.code == 4108 ||
                  commonResponse.code == 4109 ||
                  commonResponse.code == 4110) {
                return commonResponse;
              }
              if (!isEmpty(commonResponse.message)) {
                UiUtils.showMyToast(
                    message: commonResponse.message,
                    messagetype: MessageType.FAILURE);
              }
              return commonResponse;
            } catch (e) {
              debugPrint(e.toString());
              return null;
            }
          }
          return null;
        }
        break;
      default:
        return null;
        break;
    }
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString(EightFoldsRetrofit.ACCESS_TOKEN);
    return accesstoken;
  }
}
