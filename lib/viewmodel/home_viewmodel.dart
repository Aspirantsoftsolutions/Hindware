import 'dart:convert';

import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../rest/eightfolds_retrofit.dart';
import '../utils/constants.dart';
import 'base_viewmodel.dart';

class HomeViewModel {
  static Future<dynamic> getAllProducts(BuildContext context) async {
    try {
      var restClient = await EightFoldsRetrofit().getRetrofitService();
      var result = await restClient.getAllProducts(
          page: 1, pageSize: Constants.PAGE_SIZE);
      await Utils.saveToSharedPraferances(
          Constants.PRODUCTS, jsonEncode(result));
      return result;
    } catch (error) {
      return BaseViewModel.handelMyError(context, error);
    }
  }

  static Future<List<Inspection>> getInspectionHistory(
      BuildContext context, String startDate, String endDate) async {
    try {
      var restClient = await EightFoldsRetrofit().getSecureRetrofitService();
      debugPrint('Data: Test');
      var result = await restClient.getInspectionHistory(
          startDate: startDate,
          endDate: endDate,
          page: 0,
          pageSize: Constants.PAGE_SIZE);
      result.sort((a, b) =>
          a.dateCreated.epochSecond.compareTo(b.dateCreated.epochSecond));
      // result = result.reversed.toList();

      var firebaseList = InspectionUtils().assignedInspevtion;

      result = result.map((e) {
        try {
          var firebaseInspection = firebaseList.singleWhere(
              (element) => element.inspectionLotNo == e.inspectionLotNo);
          if (firebaseInspection != null) {
            e.cloneTo(firebaseInspection);
          }
        } catch (e) {
          debugPrint(e.toString());
        }

        return e;
      }).toList();

      debugPrint('Data: ${result.toString()}');
      return result;
    } catch (error) {
      debugPrint('Data: ${error.toString()}');
      BaseViewModel.handelMyError(context, error);
    }
  }
}
