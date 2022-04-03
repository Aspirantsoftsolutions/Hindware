import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SomanyHIL/rest/rest_client.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';

class EightFoldsRetrofit {
  static const String ACCESS_TOKEN = 'ACCESS_TOKEN';

  // static const String BASE_URL = 'http://15.207.197.25/hindware/'; // Old Live
  static const String BASE_URL = 'https://api.shilgroup.com/hindware/'; // Live

  static const String GET_FILE_URL = BASE_URL + 'file/';
  static const String GET_REFERENCE_FILE_URL = GET_FILE_URL + "reference/";
  static const String GET_CAPTURED_FILE_URL = GET_FILE_URL + "captured/";
  static const String GET_SIGNATURE_FILE_URL = GET_FILE_URL + "signature/";

  Future<RestClient> getRetrofitService() async {
    // config your dio headers globally
    var dio = await _getHeaders();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return RestClient(dio);
  }

  Future<RestClient> getSecureRetrofitService(
      {String userName, String password}) async {
    // config your dio headers globally
    var dio = await _getSecureHeaders(userName: userName, password: password);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return RestClient(dio);
  }

  Future<Dio> _getHeaders() async {
    final dio = Dio(); // Provide a dio instance

    dio.options.contentType = "application/json";

    return dio;
  }

  Future<Dio> _getSecureHeaders({String userName, String password}) async {
    var accessToken = await _getAccessToken();

    final dio = Dio(); // Provide a dio instance

    dio.options.contentType = "application/json";
    if (userName != null && password != null) {
      dio.options.headers["Authorization"] =
          _getBasicHeader(userName, password);
    } else if (!isEmpty(accessToken)) {
      dio.options.headers["Authorization"] = "Bearer $accessToken";
    }
    dio.options.headers["isRefreshToken"] = "true";
    return dio;
  }

  String _getBasicHeader(String userName, String password) {
    var header = 'Basic ${base64Encode(("$userName:$password").codeUnits)}';
    return header;
  }

  Future<String> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString(ACCESS_TOKEN);
    debugPrint("Access Token: " + accesstoken);
    return accesstoken;
  }

  static Future<bool> isNetworkAvailable({bool showToast = true}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (showToast) {
        UiUtils.showMyToast(
            message: 'No network available...',
            messagetype: MessageType.FAILURE);
      }
      return false;
    }
    return true;
  }
}
