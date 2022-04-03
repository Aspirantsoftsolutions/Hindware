import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:SomanyHIL/firebase/firebase_utils.dart';
import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/model/inspection_group_detail.dart';
import 'package:SomanyHIL/model/inspection_overall_observation.dart';
import 'package:SomanyHIL/model/inspection_serial_no_details.dart';
import 'package:SomanyHIL/model/my_instant.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/viewmodel/inspection_viewmobel.dart';

import 'inspection_signature.dart';

part 'inspection.g.dart';

@JsonSerializable()
class Inspection {
  static const String INSPECTION_STATUS_ASSIGNED = "ASSIGNED";
  static const String INSPECTION_STATUS_MODIFIED = "MODIFIED";
  static const String INSPECTION_STATUS_RESULT_RECORDING = "RESULT_RECORDING";
  static const String INSPECTION_STATUS_USAGE_DECISION = "USAGE_DECISION";
  static const String INSPECTION_STATUS_USAGE_DECISION_TAKEN =
      "USAGE_DECISION_TAKEN_BY_APP";
  static const String INSPECTION_STATUS_SUBMITTED_BY_APP = "SUBMITTED_BY_APP";
  static const String INSPECTION_STATUS_SUBMITTED_TO_CLIENT =
      "SUBMITTED_TO_CLIENT";

  String inspectionLotNo;
  MyInstant dateCreated;
  String clientUserId;
  String materialNo;
  String materialDesc;
  String materialModel;
  String materialModelName;
  String plant;
  int poQuality;

  double noOfItemsInBOM;
  double noOfItemsInFG;

  String bomTitle;
  String fgTitle;
  String poNumber;
  String version;
  // List<Inspection> versions = [];

  List<InspectionDetail> bomInspectionDetails;
  List<InspectionDetail> fgInspectionDetails;

  bool fgFinished;
  bool baseLot;
  bool bomFinished;

  //TOBE added after inspection completed
  double inspectedQuality;
  double vqty;
  double toBeInspected;
  int decision; //0 -for not captured, 1- for accepted, 2-for rejected
  String remarks;

  MyInstant inspectionStartTime;
  MyInstant inspectionEndTime;

  String status;
  MyInstant createdTime;
  MyInstant modifiedTime;
  bool deleted;

  String assignedToUserId;
  InspectionSignature inspectionSignature;
  List<InspectionOverallObservation> overallObservations;
  InspectionSerialNoDetails inspectionSerialNoDetails;

  List<InspectionGroupDetail> inspectionGroupDetails;
  String vendorMailId;

  cloneTo(Inspection inspection) {
    poQuality = inspection.poQuality;
    inspectionGroupDetails = inspection.inspectionGroupDetails;
    inspectionSerialNoDetails = inspection.inspectionSerialNoDetails;
    overallObservations = inspection.overallObservations;
    inspectionSignature = inspection.inspectionSignature;
    remarks = inspection.remarks;
    decision = inspection.decision;
    inspectedQuality = inspection.inspectedQuality;
    vqty = inspection.vqty;
    bomInspectionDetails = inspection.bomInspectionDetails;
    fgInspectionDetails = inspection.fgInspectionDetails;
    // versions = inspection.versions;
  }

  Inspection(
      {this.inspectionLotNo,
      this.dateCreated,
      this.clientUserId,
      this.materialNo,
      this.materialDesc,
      this.materialModel,
      this.materialModelName,
      this.plant,
      this.poQuality,
      this.noOfItemsInBOM,
      this.noOfItemsInFG,
      this.bomTitle,
      this.fgTitle,
      this.poNumber,
        this.version,
      this.bomInspectionDetails,
        this.vqty,
        // this.versions,
      this.fgInspectionDetails,
      this.fgFinished,
        this.baseLot,
      this.bomFinished,
      this.inspectedQuality,
      this.toBeInspected,
      this.decision,
      this.remarks,
      this.inspectionStartTime,
      this.inspectionEndTime,
      this.status,
      this.createdTime,
      this.modifiedTime,
      this.deleted,
      this.assignedToUserId,
      this.overallObservations,
      this.inspectionGroupDetails,
      this.vendorMailId});

  Future<void> uploadImages() async {
    if (bomInspectionDetails != null)
      for (var inspectionDetail in bomInspectionDetails) {
        if (inspectionDetail.isFilePendingToUpload()) {
          List<String> tempList = [];
          for (var capturedImage in inspectionDetail?.capturedImages ?? []) {
            if (InspectionUtils().inUseInspectionLotNo == inspectionLotNo) {
              break;
            }
            if (capturedImage != null) {
              var fileId = await uploadFileToServer(
                  capturedImage, inspectionDetail?.mastCharac ?? '');
              if (fileId != null) {
                capturedImage = fileId;
                tempList.add(fileId);
              }
            }
          }

          if (InspectionUtils().inUseInspectionLotNo == inspectionLotNo) {
            break;
          }

          inspectionDetail.capturedImages = tempList;

          if (InspectionUtils().inUseInspectionLotNo != inspectionLotNo) {
            debugPrint('Test addToFirebase bom images: $inspectionLotNo');
            await addToFirebase(modified: false);
          }
        }
      }

    if (fgInspectionDetails != null)
      for (var inspectionDetail in fgInspectionDetails) {
        if (inspectionDetail.isFilePendingToUpload()) {
          List<String> tempList = [];
          for (var capturedImage in inspectionDetail?.capturedImages ?? []) {
            if (InspectionUtils().inUseInspectionLotNo == inspectionLotNo) {
              break;
            }
            if (capturedImage != null) {
              var fileId = await uploadFileToServer(
                  capturedImage, inspectionDetail?.mastCharac ?? '');
              if (fileId != null) {
                capturedImage = fileId;
                tempList.add(fileId);
              }
            }
          }

          if (InspectionUtils().inUseInspectionLotNo == inspectionLotNo) {
            break;
          }

          inspectionDetail.capturedImages = tempList;

          if (InspectionUtils().inUseInspectionLotNo != inspectionLotNo) {
            debugPrint('Test addToFirebase fg images: $inspectionLotNo');
            await addToFirebase(modified: false);
          }
        }
      }
    if (inspectionSignature != null &&
        InspectionUtils().inUseInspectionLotNo != inspectionLotNo) {
      debugPrint('Uploading signature: $inspectionLotNo');
      var fileId = await uploadSignatureToServer(
          inspectionSignature?.inspectorSignatureId);
      if (fileId != null) {
        inspectionSignature?.inspectorSignatureId = fileId;
      }
      var fileId1 = await uploadSignatureToServer(
          inspectionSignature?.factoryRepresentativeSignatureId);
      if (fileId1 != null) {
        inspectionSignature?.factoryRepresentativeSignatureId = fileId1;
      }

      if (InspectionUtils().inUseInspectionLotNo != inspectionLotNo) {
        debugPrint('Test addToFirebase signature images: $inspectionLotNo');
        await addToFirebase(modified: false);
      }
    }
  }

/*  Future<String> uploadFileToServer(String capturedImage) async {
    if (capturedImage.contains('/')) {
      var appFile = await InspectionViewModel.uploadImage(capturedImage);
      if (appFile != null) {
        await DefaultCacheManager().getSingleFile(
            EightFoldsRetrofit.GET_CAPTURED_FILE_URL + appFile.fileId);
        return appFile.fileId;
      }
    }
    return capturedImage;
  }*/

  Future<String> uploadFileToServer(
      String capturedImage, String mastCharac) async {
    if (capturedImage.contains('/')) {
      var appFile;
      if(version!=null && version!=''){
        appFile = await InspectionViewModel.uploadCapturedImage(
            capturedImage, materialModel ?? '', inspectionLotNo+version, mastCharac);
      }else{
        appFile = await InspectionViewModel.uploadCapturedImage(
            capturedImage, materialModel ?? '', inspectionLotNo, mastCharac);
      }

      if (appFile != null) {
        await DefaultCacheManager().getSingleFile(
            EightFoldsRetrofit.GET_CAPTURED_FILE_URL + appFile.fileId);
        return appFile.fileId;
      }
    }
    return capturedImage;
  }

  Future<String> uploadSignatureToServer(
    String capturedImage,
  ) async {
    if (capturedImage.contains('/')) {
      var appFile;
      if(version!=null && version!=''){
        appFile = await InspectionViewModel.uploadSignatureImage(
            capturedImage, inspectionLotNo+version);
      }else{
        appFile = await InspectionViewModel.uploadSignatureImage(
            capturedImage,inspectionLotNo);
      }

      if (appFile != null) {
        await DefaultCacheManager().getSingleFile(
            EightFoldsRetrofit.GET_SIGNATURE_FILE_URL + appFile.fileId);
        return appFile.fileId;
      }
    }
    return capturedImage;
  }

  bool isFilePendingToUpload() {
    var bomPresent = bomInspectionDetails?.firstWhere(
        (element) => (element.capturedImages?.firstWhere(
                (element1) => element1.contains('/'),
                orElse: () => null) !=
            null),
        orElse: () => null);
    if (bomPresent != null) {
      return true;
    }

    var fgPresent = fgInspectionDetails?.firstWhere(
        (element) => (element.capturedImages?.firstWhere(
                (element1) => element1.contains('/'),
                orElse: () => null) !=
            null),
        orElse: () => null);
    if (fgPresent != null) {
      return true;
    }
    if (inspectionSignature != null &&
        (inspectionSignature.inspectorSignatureId.contains('/') ||
            inspectionSignature.inspectorSignatureId.contains('/'))) {
      return true;
    }
    return false;
  }

  Future<void> addToFirebase(
      {String newStatus = INSPECTION_STATUS_MODIFIED, bool modified}) async {
    status = newStatus;
    if (modified) {
      inspectionSignature = null;
    }
    var json = toJson();
    debugPrint('Json: $json');

    FirebaseUtils.getUsersReference().doc(inspectionLotNo+version).get().then((value) =>
    {
      if(value.exists){
        FirebaseUtils.getUsersReference()
        .doc(inspectionLotNo+version)
        .update(toJson())
      }else{
        if(decision == 0){
          FirebaseUtils.getUsersReference()
              .doc(inspectionLotNo+version)
              .set(toJson())
              .then((value) => {
            FirebaseUtils.getUsersReference()
                .doc(inspectionLotNo+version)
                .update({'baseLot': false})
                .then((value) => {print("v1 version Updated")})
                .catchError((error) => {print("Failed to update v1 version: $error")})

          }).catchError((error) => {print("Failed to update v1: $error")})
        }
      }
    });

    // if(version !=null && version !=''){
    //   await FirebaseUtils.getUsersReference()
    //       .doc(inspectionLotNo+version)
    //       .update(toJson());
    // }else{
    //   FirebaseUtils.getUsersReference().doc(inspectionLotNo).get().then((value) =>
    //     {
    //       FirebaseUtils.getUsersReference()
    //           .doc(inspectionLotNo+"_v1")
    //           .set(value.data())
    //           .then((value) => {
    //             // print("v1 Updated")
    //           FirebaseUtils.getUsersReference()
    //               .doc(inspectionLotNo+"_v1")
    //               .update({'version': "v1"})
    //               .then((value) => {print("v1 version Updated")})
    //               .catchError((error) => {print("Failed to update v1 version: $error")})
    //
    //       })
    //           .catchError((error) => {print("Failed to update v1: $error")})
    //     }
    //   );
    //   // await FirebaseUtils.getUsersReference()
    //   //     .doc(inspectionLotNo)
    //   //     .update(toJson());
    // }
  }

  bool isInspectionCompleted() {
    var remarkesMandatory =
        (decision == 1 || (decision == 2 && (remarks ?? '').isNotEmpty));
    if (getBomStatusCode() == 'green' &&
        getFGStatusCode() == 'green' &&
        remarkesMandatory &&
        (decision != null && (decision == 1 || decision == 2))) {
      return true;
    } else {
      return false;
    }
  }

  bool isUDCompleted() {
    return (remarks != null && remarks.isNotEmpty) &&
        (decision != null && (decision == 1 || decision == 2));
  }

  bool isFGInspectionCompleted() {
    // var isp2 = fgInspectionDetails?.firstWhere(
    //     (element) => ((element.decision == null ||
    //             (element.decision != null &&
    //                 (element?.decision != 1 || element?.decision != 2))) &&
    //         (element.result == null ||
    //             (element.result != null && element.result.isEmpty)) &&
    //         (element.capturedImages == null ||
    //             (element.capturedImages != null &&
    //                 element.capturedImages.length == 0))),
    //     orElse: () => null);
    var isp2 = fgInspectionDetails?.firstWhere(
        (element) => (!element.isInspectionCompleted()),
        orElse: () => null);

    return (isp2 == null);
  }

  bool isFGFilePendingToUpload() {
    var fgPresent = fgInspectionDetails?.firstWhere(
        (element) => (element.capturedImages?.firstWhere(
                (element1) => element1.contains('/'),
                orElse: () => null) !=
            null),
        orElse: () => null);
    if (fgPresent != null) {
      return true;
    }

    return false;
  }

  bool isBOMInspectionCompleted() {
    // var isp1 = bomInspectionDetails?.firstWhere(
    //     (element) => ((element.decision == null ||
    //             (element.decision != null &&
    //                 (element?.decision != 1 || element?.decision != 2))) &&
    //         (element.result == null ||
    //             (element.result != null && element.result.isEmpty)) &&
    //         (element.capturedImages == null ||
    //             (element.capturedImages != null &&
    //                 element.capturedImages.length == 0))),
    //     orElse: () => null);

    var isp1 = bomInspectionDetails?.firstWhere(
        (element) => (!element.isInspectionCompleted()),
        orElse: () => null);

    return (isp1 == null);
  }

  bool isSignatureCompleted() {
    if (inspectionSignature != null &&
        (inspectionSignature.inspectorSignatureId != null &&
            inspectionSignature.inspectorSignatureId.isNotEmpty) &&
        (inspectionSignature.factoryRepresentativeSignatureId != null &&
            inspectionSignature.factoryRepresentativeSignatureId.isNotEmpty)) {
      return true;
    } else {
      return false;
    }
  }

  bool isBOMFilePendingToUpload() {
    var bomPresent = bomInspectionDetails?.firstWhere(
        (element) => (element.capturedImages?.firstWhere(
                (element1) => element1.contains('/'),
                orElse: () => null) !=
            null),
        orElse: () => null);
    if (bomPresent != null) {
      return true;
    }
    return false;
  }

  bool isOverallObservationCompleted() {
    var length = overallObservations?.length ?? 0;
    if (length > 0) {
      var lastObservation = overallObservations[overallObservations.length - 1];
      if (!(lastObservation.actionTaken?.isEmpty ?? true) &&
          !(lastObservation.observations?.isEmpty ?? true) &&
          !(lastObservation.status?.isEmpty ?? true)) {
        return true;
      }
    }
    return false;
  }

  bool isinspectionSerialNoDetailCompleted() {
    var sampleSize = inspectionSerialNoDetails?.sampleSize ?? 0;
    var sampleLotSrNoSize =
        inspectionSerialNoDetails?.sampleLotSrNo?.length ?? 0;
    if (inspectionSerialNoDetails != null &&
        sampleSize > 0 &&
        !(inspectionSerialNoDetails?.lotStartSrNo?.isEmpty ?? true) &&
        !(inspectionSerialNoDetails?.lotLastSrNo?.isEmpty ?? true) &&
        sampleLotSrNoSize == sampleSize) {
      return true;
    }
    return false;
  }

  String getBomStatusCode() {
    debugPrint('getBomStatusCode');
    String status = 'red';
    if (isBOMInspectionCompleted()) {
      debugPrint('isBOMInspectionCompleted');
      status = isBOMFilePendingToUpload() ? 'orange' : 'green';
    }
    debugPrint('$status');
    return status;
  }

  String getUDStatusCode() {
    String status = isUDCompleted() ? 'green' : 'red';
    return status;
  }

  String getFGStatusCode() {
    String status = 'red';
    if (isFGInspectionCompleted()) {
      status = isFGFilePendingToUpload() ? 'orange' : 'green';
    }
    return status;
  }

  double getToBeInspect() {
    double status = 0;
    if (poQuality != null && inspectedQuality != null) {
      status = (poQuality ?? 0) - (inspectedQuality ?? 0);
      if(vqty != null){
        status = status - (vqty ?? 0);
      }
    }
    return status;
  }

  /*int getIntPoQuality() {
    int num = 0;
    if (poQuality != null && poQuality.isNotEmpty) {
      try {
        num = int.parse(poQuality);
      } catch (e) {}
    }
    return num;
  }*/

  factory Inspection.fromJson(Map<String, dynamic> json) {
    try {
      var value = json["dateCreated"];
      if (value != null && (value is String)) {
        var timestamp = DateTime.parse(value);
        var epoch = timestamp.millisecondsSinceEpoch;
        var nano = timestamp.microsecondsSinceEpoch;
        var myInstant = MyInstant(epochSecond: epoch, nano: nano);
        json["dateCreated"] = myInstant.toJson();
      }
      // json["dateCreated"] =
      //     ((json["dateCreated"] as Timestamp).toDate().toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      var value = json["inspectionStartTime"];
      if (value != null && (value is String)) {
        var timestamp = DateTime.parse(value);
        var epoch = timestamp.millisecondsSinceEpoch;
        var nano = timestamp.microsecondsSinceEpoch;
        var myInstant = MyInstant(epochSecond: epoch, nano: nano);
        json["inspectionStartTime"] = myInstant.toJson();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      var value = json["inspectionEndTime"];
      if (value != null && (value is String)) {
        var timestamp = DateTime.parse(value);
        var epoch = timestamp.millisecondsSinceEpoch;
        var nano = timestamp.microsecondsSinceEpoch;
        var myInstant = MyInstant(epochSecond: epoch, nano: nano);
        json["inspectionEndTime"] = myInstant.toJson();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      var value = json["createdTime"];
      if (value != null && (value is String)) {
        var timestamp = DateTime.parse(value);
        var epoch = timestamp.millisecondsSinceEpoch;
        var nano = timestamp.microsecondsSinceEpoch;
        var myInstant = MyInstant(epochSecond: epoch, nano: nano);
        json["createdTime"] = myInstant.toJson();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      var value = json["modifiedTime"];
      if (value != null && (value is String)) {
        var timestamp = DateTime.parse(value);
        var epoch = timestamp.millisecondsSinceEpoch;
        var nano = timestamp.microsecondsSinceEpoch;
        var myInstant = MyInstant(epochSecond: epoch, nano: nano);
        json["modifiedTime"] = myInstant.toJson();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return _$InspectionFromJson(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'inspectionLotNo': inspectionLotNo,
        'vendorMailId': vendorMailId,
        'dateCreated': dateCreated?.toJson(),
        'clientUserId': clientUserId,
        'materialNo': materialNo,
        'materialDesc': materialDesc,
        'materialModel': materialModel,
        'materialModelName': materialModelName,
        'plant': plant,
        'poQuality': poQuality,
        'noOfItemsInBOM': noOfItemsInBOM,
        'noOfItemsInFG': noOfItemsInFG,
        'bomTitle': bomTitle,
        'fgTitle': fgTitle,
        'poNumber': poNumber,
         'version':version,
    // 'versions':
    // versions?.map((v) => v.toJson())?.toList(),
        'bomInspectionDetails':
            bomInspectionDetails?.map((v) => v.toJson())?.toList(),
        'fgInspectionDetails':
            fgInspectionDetails?.map((v) => v.toJson())?.toList(),
        'overallObservations':
            overallObservations?.map((v) => v.toJson())?.toList(),
        'inspectionGroupDetails':
            inspectionGroupDetails?.map((v) => v.toJson())?.toList(),
        'fgFinished': fgFinished,
        'baseLot':baseLot,
        'bomFinished': bomFinished,
        'inspectedQuality': inspectedQuality,
        'vqty': vqty,
        'toBeInspected': toBeInspected,
        'decision': decision,
        'remarks': remarks,
        'inspectionStartTime': inspectionStartTime?.toJson(),
        'inspectionEndTime': inspectionEndTime?.toJson(),
        'status': status,
        'createdTime': createdTime?.toJson(),
        'modifiedTime': modifiedTime?.toJson(),
        'deleted': deleted,
        'assignedToUserId': assignedToUserId,
        'inspectionSignature': inspectionSignature?.toJson(),
        'inspectionSerialNoDetails': inspectionSerialNoDetails?.toJson(),
      };

  Map<String, dynamic> toJsonForServer() => <String, dynamic>{
        'inspectionLotNo': inspectionLotNo,
        'vendorMailId': vendorMailId,
        'dateCreated': dateCreated?.stringDate(),
        'clientUserId': clientUserId,
        'materialNo': materialNo,
        'materialDesc': materialDesc,
        'materialModel': materialModel,
        'materialModelName': materialModelName,
        'plant': plant,
        'poQuality': poQuality,
        'noOfItemsInBOM': noOfItemsInBOM,
        'noOfItemsInFG': noOfItemsInFG,
        'bomTitle': bomTitle,
        'fgTitle': fgTitle,
        'poNumber': poNumber,
        'version':version,
    // 'versions':
    // versions?.map((v) => v.toJson())?.toList(),
        'bomInspectionDetails':
            bomInspectionDetails?.map((v) => v.toJson())?.toList(),
        'fgInspectionDetails':
            fgInspectionDetails?.map((v) => v.toJson())?.toList(),
        'overallObservations':
            overallObservations?.map((v) => v.toJson())?.toList(),
        'inspectionGroupDetails':
            inspectionGroupDetails?.map((v) => v.toJson())?.toList(),
        'fgFinished': fgFinished,
        'baseLot': baseLot,
        'bomFinished': bomFinished,
        'inspectedQuality': inspectedQuality,
        'vqty':vqty,
        'toBeInspected': toBeInspected,
        'decision': decision,
        'remarks': remarks,
        'inspectionStartTime': inspectionStartTime?.stringDate(),
        'inspectionEndTime': inspectionEndTime?.stringDate(),
        'status': status,
        'createdTime': createdTime?.stringDate(),
        'modifiedTime': modifiedTime?.stringDate(),
        'deleted': deleted,
        'assignedToUserId': assignedToUserId,
        'inspectionSignature': inspectionSignature?.toJson(),
        'inspectionSerialNoDetails': inspectionSerialNoDetails?.toJson(),
      };
}
