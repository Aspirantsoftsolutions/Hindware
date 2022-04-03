import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/utils/constants.dart';

part 'inspection_detail.g.dart';

@JsonSerializable()
class InspectionDetail {
  String characNo;
  String mastCharac;
  String shortDesc;
  String referenceImage;
  String localReferenceImage;
  String frequency;
  String type;
  String specification;

  String result;
  int decision; //0 -for not captured, 1- for accepted, 2-for rejected
  int noOfMeasurements;
  String remarks;
  List<String> capturedImages; // Max six images
  List<String> quantitativeResult; // Max 5 result
  double minSpec; // to compare result
  double maxSpec; // to compare result
  String groupNum;
  String uniqueNumber;
  bool samplingFreqType;
  bool alphaNumericResult;

  InspectionDetail({
    this.characNo,
    this.mastCharac,
    this.shortDesc,
    this.referenceImage,
    this.localReferenceImage,
    this.frequency,
    this.type,
    this.specification,
    this.result,
    this.decision,
    this.noOfMeasurements,
    this.remarks,
    this.capturedImages,
    this.quantitativeResult,
    this.minSpec,
    this.maxSpec,
    this.groupNum,
    this.samplingFreqType,
    this.uniqueNumber,
    this.alphaNumericResult,
  });

  factory InspectionDetail.fromJson(Map<String, dynamic> json) {
    return _$InspectionDetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$InspectionDetailToJson(this);

  bool isInspectionCompleted() {
    bool resultCheck = true;
    if ((type != null && type == Constants.INSPECTION_TYPE_QUANTITATIVE) &&
        (result == null || (result != null && result.isEmpty))) {
      resultCheck = false;
    }
    return (((decision != null && (decision == 1 || decision == 2)) &&
        resultCheck));
  }

  bool isFilePendingToUpload() {
    var bomPresent = capturedImages
        ?.firstWhere((element1) => element1.contains('/'), orElse: () => null);
    if (bomPresent != null) {
      return true;
    }
    return false;
  }

  String getStatusCode() {
    String status = 'red';
    if (isInspectionCompleted()) {
      status = isFilePendingToUpload() ? 'orange' : 'green';
    }
    return status;
  }

  bool isValidResult(String text) {
    if (text.isNotEmpty) {
      try {
        double i = double.parse(text);
        return ((i >= (minSpec ?? 0)) && (i <= (maxSpec ?? 0)));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return false;
  }

  bool validateResult() {
    if (alphaNumericResult ?? false == true) {
      return false;
    }
    if (maxSpec == null ||
        minSpec == null ||
        type == null ||
        (type != null && type == 'text')) {
      return false;
    }
    return result != null && result.isNotEmpty && !isValidResult(result);
  }

  bool isText() {
    return (type != null && type == 'text');
  }

  bool isAlphaNumeric() {
    return (alphaNumericResult ?? false == true);
  }

  bool validateResultForQuant(int index) {
    if (alphaNumericResult ?? false == true) {
      return false;
    }
    if (maxSpec == null ||
        minSpec == null ||
        type == null ||
        (type != null && type == 'text')) {
      return false;
    }
    return quantitativeResult != null &&
        quantitativeResult[index] != null &&
        quantitativeResult[index].isNotEmpty &&
        !isValidResult(quantitativeResult[index]);
  }

  bool showResult() {
    if (((specification ?? '').isNotEmpty) ||
        (alphaNumericResult ?? false == true)) {
      return true;
    }
    return false;
  }

  Future<bool> downloadRefImages() async {
    if (referenceImage == null ||
        (referenceImage != null && referenceImage.isEmpty)) return false;
    debugPrint(
        "downloading ${characNo ?? ''} URL  ${EightFoldsRetrofit.GET_REFERENCE_FILE_URL + referenceImage}");
    debugPrint("downloading ref image from inspection detail");
    try {
      await DefaultCacheManager().getSingleFile(
          EightFoldsRetrofit.GET_REFERENCE_FILE_URL + referenceImage);
    } catch (e) {
      debugPrint(e.toString());
    }

    return true;
  }

  Future<bool> downloadCapturedImages() async {
    if (capturedImages == null ||
        (capturedImages != null && capturedImages.length == 0)) return false;

    for (var url in capturedImages) {
      if ((url != null && url.isNotEmpty && !url.contains('/'))) {
        debugPrint(
            "downloading ${characNo ?? ''} URL  ${EightFoldsRetrofit.GET_CAPTURED_FILE_URL + url}");
        debugPrint("downloading captured image from inspection detail");
        try {
          await DefaultCacheManager()
              .getSingleFile(EightFoldsRetrofit.GET_CAPTURED_FILE_URL + url);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
    return true;
  }

  bool isReferenceImageAvailable() {
    debugPrint('ReferenceImage: $referenceImage');
    return (referenceImage != null && referenceImage.isNotEmpty);
    // return false;
  }
}
