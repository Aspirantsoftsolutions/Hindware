import 'dart:convert';

import 'package:SomanyHIL/model/app_file.dart';
import 'package:SomanyHIL/model/common_response.dart';
import 'package:SomanyHIL/model/file_response.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:SomanyHIL/viewmodel/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class InspectionViewModel extends BaseViewModel {
  static Future<AppFile> uploadImage(String filePath,
      {BuildContext context}) async {
    // var pd = MyDialog.showProgressDialog(context);
    try {
      var uri = Uri.parse('${EightFoldsRetrofit.BASE_URL}file/upload');

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = await http.MultipartFile.fromPath("file", filePath);

      request.files.add(multipartFile);
      var response = await request.send();
      // pd.hide();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var fileResponse = FileResponse.fromJson(json.decode(responseString));
        var appFile = fileResponse.data;
        return appFile;
      } else {
        return null;
      }
    } catch (error) {
      // pd.hide();
      return null;
      // BaseViewModel.handelMyError(context, error);
      // throw error;
    }
  }

  static Future<AppFile> uploadCapturedImage(String filePath,
      String materialModel, String inspectionLotNo, String mastCharac,
      {BuildContext context}) async {
    // var pd = MyDialog.showProgressDialog(context);
    try {
      var uri = Uri.parse(
          '${EightFoldsRetrofit.BASE_URL}file/upload/captured/$materialModel/$inspectionLotNo/$mastCharac');

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = await http.MultipartFile.fromPath("file", filePath);

      request.files.add(multipartFile);
      var response = await request.send();
      // pd.hide();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var fileResponse = FileResponse.fromJson(json.decode(responseString));
        var appFile = fileResponse.data;
        return appFile;
      } else {
        return null;
      }
    } catch (error) {
      // pd.hide();
      return null;
      // BaseViewModel.handelMyError(context, error);
      // throw error;
    }
  }

  static Future<AppFile> uploadSignatureImage(
      String filePath, String inspectionLotNo,
      {BuildContext context}) async {
    // var pd = MyDialog.showProgressDialog(context);
    try {
      var uri = Uri.parse(
          '${EightFoldsRetrofit.BASE_URL}file/upload/signature/$inspectionLotNo/');

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = await http.MultipartFile.fromPath("file", filePath);

      request.files.add(multipartFile);
      var response = await request.send();
      // pd.hide();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var fileResponse = FileResponse.fromJson(json.decode(responseString));
        var appFile = fileResponse.data;
        return appFile;
      } else {
        return null;
      }
    } catch (error) {
      // pd.hide();
      return null;
      // BaseViewModel.handelMyError(context, error);
      // throw error;
    }
  }

  /*static Future<dynamic> submitInspection(List<Inspection> list) async {
    try {
      var s = jsonEncode(list);
      print("$s");
      var restClient = await EightFoldsRetrofit().getSecureRetrofitService();
      var result = await restClient.submitInspections(list: list);
      return result;
    } catch (error) {
      return null;
    }
  }*/

  static Future<dynamic> submitInspection(
      List<Map<String, dynamic>> list) async {
    try {
      var s = jsonEncode(list);
      print("$s");
      var restClient = await EightFoldsRetrofit().getSecureRetrofitService();
      var result = await restClient.submitInspections(list: s);
      return result;
    } catch (error) {
      if (error is DioError) {
        final data = error.response.data;
        if (data != null) {
          var commonResponse = CommonResponse.fromJson(data);
          if (commonResponse.code == 401) {
            var restClient =
                await EightFoldsRetrofit().getSecureRetrofitService();
            var result = await restClient.getRefreshToken();
            await Utils.saveToSharedPraferances(
                EightFoldsRetrofit.ACCESS_TOKEN, result.token);
            debugPrint('');
          }
        }
      }
      return error;
    }
  }
}
