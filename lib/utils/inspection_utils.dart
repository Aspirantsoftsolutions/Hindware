import 'package:SomanyHIL/firebase/firebase_utils.dart';
import 'package:SomanyHIL/model/common_response.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/viewmodel/inspection_viewmobel.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class InspectionUtils {
  static final InspectionUtils _singleton = InspectionUtils._internal();

  factory InspectionUtils() {
    return _singleton;
  }

  InspectionUtils._internal();

  List<Inspection> assignedInspevtion = [];
  // List<Inspection> assignedInspevtionTemp = [];
  String inUseInspectionLotNo;
  bool isUploadingImages = false;
  bool isSyncStarted = false;
  bool fileDownload = false;

  bool isAnyNewInspection(List<DocumentChange> changes) {
    var lotNumbers = assignedInspevtion.map((e) => e.inspectionLotNo).toList();
    for (DocumentChange element in changes) {
      debugPrint('Document id: ${element.doc.id}');
      if (!lotNumbers.contains(element.doc.id)) {
        return true;
      }
    }
    return false;
  }

  updateChangedDoc(List<DocumentChange> changes) {
    changes.forEach((element) {
      _parseInspection(element);
    });
  }

  _parseInspection(DocumentChange doc) async {
    Map<String, dynamic> data = doc.doc.data();
    var inspaction = Inspection.fromJson(data);

   if(inspaction.baseLot == null){
      FirebaseUtils.getUsersReference()
          .doc(inspaction.inspectionLotNo)
          .update({'baseLot': false})
          .then((value) => {print("baseLot Updated")})
          .catchError((error) => {print("Failed to update baseLot version: $error")});
   }
    if(inspaction.version == null){
      FirebaseUtils.getUsersReference()
          .doc(inspaction.inspectionLotNo)
          .update({'version': '_v1'})
          .then((value) => {print("version Updated")})
          .catchError((error) => {print("Failed to update version version: $error")});
    }

    assignedInspevtion.removeWhere((element) {
      return (element.inspectionLotNo == inspaction.inspectionLotNo && element.baseLot == false);
      // return ((element.inspectionLotNo == inspaction.inspectionLotNo));
    });
    // final ids = assignedInspevtion.map((e) => e.inspectionLotNo).toSet();
    // assignedInspevtion.retainWhere((x) => ids.remove(x.inspectionLotNo));
    if (doc.newIndex == -1) {
      return;
    }
    assignedInspevtion.add(inspaction);
  }

  // isAvailableData(inspaction) {
  //   bool isAvailable = false;
  //   for (int i = 0; i < assignedInspevtionTemp.length; i++) {
  //     if (assignedInspevtionTemp[i].inspectionLotNo == inspaction.inspectionLotNo) {
  //       isAvailable = true;
  //     }
  //   }
  //   return isAvailable;
  // }

  List<Inspection> getInspactionByProductCatalogId(String materialNo) {
    return assignedInspevtion
        .where((element) => element.materialNo == materialNo)
        .toList();
  }

  Inspection getInspactionByInspectionLotNo(String inspectionLotNo) {
    return assignedInspevtion
        .firstWhere((element) => element.inspectionLotNo == inspectionLotNo);
  }

  // addInspectionDocumentVersion(Inspection inspection) async{
  //   for(int i=0;i<assignedInspevtionTemp.length;i++){
  //     if(assignedInspevtionTemp[i].inspectionLotNo == inspection.inspectionLotNo){
  //       await FirebaseUtils.getUsersReference()
  //           .doc(assignedInspevtionTemp[i].inspectionLotNo + "_v1").set(assignedInspevtionTemp[i].toJson())
  //           .then((value) => {
  //             print("User Updated")
  //           })
  //           .catchError((error) => {
  //             print("Failed to update user: $error")
  //           });
  //     }
  //   }
  // }

  uploadAllInspection() async {
    if (isSyncStarted || isUploadingImages || fileDownload) {
      BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
      return;
    }
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
    isSyncStarted = true;
    if (anyFilePendingToUpload()) {
      await uploadImages();
    } else {
      var tempAssignedInspevtion = [];
      tempAssignedInspevtion.addAll(assignedInspevtion);
      for (var inspection in tempAssignedInspevtion) {
        await _submitInspectionToServer(inspection);
      }
    }
    isSyncStarted = false;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  Future<void> uploadImages() async {
    var isNetwork =
    await EightFoldsRetrofit.isNetworkAvailable(showToast: false);
    if (!isNetwork) {
      return;
    }

    if (isUploadingImages || !anyFilePendingToUpload()) {
      isUploadingImages = false;
      return;
    }
    isUploadingImages = true;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
    try {
      var tempAssignedInspevtion = [];
      tempAssignedInspevtion.addAll(assignedInspevtion);
      for (var inspection in tempAssignedInspevtion) {
        // if (inspection.inspectionLotNo == inUseInspectionLotNo) continue;
        debugPrint('Test for: ${inspection.inspectionLotNo}');
        if (inspection.isFilePendingToUpload()) {
          debugPrint('Test uploadImages: ${inspection.inspectionLotNo}');
          await inspection.uploadImages();
          debugPrint(
              'Test _submitInspectionToServer: ${inspection.inspectionLotNo}');
          await _submitInspectionToServer(inspection);
        }
      }
    } catch (e) {
      debugPrint('uploadImages: ${e.toString()}');
    }

    isUploadingImages = false;
    if (!isSyncStarted) {
      BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
    }
    // uploadImages();
  }

  Future<CommonResponse> _submitInspectionToServer(
      Inspection inspection) async {
    var isBOMInspectionCompleted = inspection.isBOMInspectionCompleted();
    var isFGInspectionCompleted = inspection.isFGInspectionCompleted();
    var isSignatureCompleted = inspection.isSignatureCompleted();
    var isOverallObservationCompleted =
    inspection.isOverallObservationCompleted();
    var isinspectionSerialNoDetailCompleted =
    inspection.isinspectionSerialNoDetailCompleted();
    var isInspectionCompleted = inspection.isInspectionCompleted();

    var readyToSync = (isBOMInspectionCompleted &&
        isFGInspectionCompleted &&
        isSignatureCompleted &&
        isinspectionSerialNoDetailCompleted &&
        isOverallObservationCompleted &&
        isInspectionCompleted &&
        ((inspection.inspectedQuality ?? 0) > 0));
    // ((inspection.poQuality ?? 0) == (inspection.inspectedQuality ?? 0)));
    debugPrint('Inspectuon loat no. ${inspection.inspectionLotNo}');
    if (inspection.status == Inspection.INSPECTION_STATUS_MODIFIED &&
        inspection.inspectionSignature != null &&
        readyToSync) {
      // inspection.status = Inspection.INSPECTION_STATUS_SUBMITTED_BY_APP;
      // if (inspection.isInspectionCompleted()) {
      inspection.status = Inspection.INSPECTION_STATUS_USAGE_DECISION_TAKEN;
      // }

      debugPrint('Submitting Data To Server');
      final Inspection tempInspec = inspection;
      var s = tempInspec.version.split('');
      int v = int.parse(s[s.length-1])+1;
      String newVersion = '_v'+v.toString();
      double newQty = tempInspec.inspectedQuality+tempInspec.vqty;
      if(tempInspec.decision ==1 || tempInspec.decision ==2){
        print('new version is,$newVersion');
        print('new version is newQty is,$newQty');
        if(newQty != tempInspec.poQuality){
          await FirebaseUtils.getUsersReference().doc(tempInspec.inspectionLotNo).get().then((value) =>
          {
            if(tempInspec.poQuality != newQty){
              FirebaseUtils.getUsersReference()
                  .doc(tempInspec.inspectionLotNo+newVersion)
                  .set(value.data())
                  .then((value) => {
                    if(tempInspec.decision ==1){
                      FirebaseUtils.getUsersReference()
                          .doc(tempInspec.inspectionLotNo+newVersion)
                          .update({'version': newVersion,'vqty': newQty})
                          .then((value) => {print("v2 version Updated")})
                          .catchError((error) => {print("Failed to update v2 version: $error")})
                    }else{
                      FirebaseUtils.getUsersReference()
                          .doc(tempInspec.inspectionLotNo+newVersion)
                          .update({'version': newVersion})
                          .then((value) => {print("v2 version Updated")})
                          .catchError((error) => {print("Failed to update v2 version: $error")})
                    }
              })
                  .catchError((error) => {print("Failed to update v2: $error")})
            }
          }
          );
          if(tempInspec.decision ==1){
            FirebaseUtils.getUsersReference()
                .doc(tempInspec.inspectionLotNo)
                .update({'version': newVersion,'vqty': newQty})
                .then((value) => {print("v2 version Updated")})
                .catchError((error) => {print("Failed to update v2 version: $error")});
          }
        }
        // updateChangedDoc(changes)

      }
      var result = await InspectionViewModel.submitInspection(
          [inspection.toJsonForServer()]);
      if (result != null && result is CommonResponse) {
        if (result.code == 2000) {
          inspection.addToFirebase(
              newStatus: inspection.status, modified: false);
        } else if (result.code == 401) {
          debugPrint('Test Test');
        }
      }
      return result;
    }
    return null;
  }

  bool anyFilePendingToUpload() {
    for (var inspection in assignedInspevtion) {
      var isPending = inspection.isFilePendingToUpload();
      if (isPending) return true;
    }
    // assignedInspevtion?.forEach((inspection) {
    //   var isPending = inspection.isFilePendingToUpload();
    //   if (isPending) return true;
    // });
    return false;
  }

  bool isFilePendingToUploadForInspection(String inspectionLotNo) {
    Inspection inspection = getInspactionByInspectionLotNo(inspectionLotNo);
    return inspection.isFilePendingToUpload();
  }

  Future<void> downloadRefImages() async {
    fileDownload = true;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
    List<Inspection> tempAssignedInspevtion = [];
    tempAssignedInspevtion.addAll(assignedInspevtion);
    _downloadBomRefImage(tempAssignedInspevtion);
    _downloadBomCapturedImage(tempAssignedInspevtion);
    _downloadFgRefImage(tempAssignedInspevtion);
    _downloadFgCapturedImage(tempAssignedInspevtion);
    // for (var inspection in assignedInspevtion) {
    //   debugPrint("downloading ref image");
    //   for (var inspectionDetails in inspection.bomInspectionDetails) {
    //     await inspectionDetails.downloadRefImages();
    //     await inspectionDetails.downloadCapturedImages();
    //   }
    //   for (var inspectionDetails in inspection.fgInspectionDetails) {
    //     await inspectionDetails.downloadRefImages();
    //     await inspectionDetails.downloadCapturedImages();
    //   }
    // }
    // fileDownload = false;
    // BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  Future<void> _downloadBomRefImage(List<Inspection> assignedInspevtion) async {
    for (var inspection in assignedInspevtion) {
      for (var inspectionDetails in inspection.bomInspectionDetails) {
        if (!fileDownload) {
          fileDownload = true;
          BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
        }
        await inspectionDetails.downloadRefImages();
      }
    }
    fileDownload = false;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  Future<void> _downloadBomCapturedImage(
      List<Inspection> assignedInspevtion) async {
    for (var inspection in assignedInspevtion) {
      for (var inspectionDetails in inspection.bomInspectionDetails) {
        if (!fileDownload) {
          fileDownload = true;
          BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
        }
        await inspectionDetails.downloadCapturedImages();
      }
    }
    fileDownload = false;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  Future<void> _downloadFgRefImage(List<Inspection> assignedInspevtion) async {
    for (var inspection in assignedInspevtion) {
      for (var inspectionDetails in inspection.fgInspectionDetails) {
        if (!fileDownload) {
          fileDownload = true;
          BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
        }
        await inspectionDetails.downloadRefImages();
      }
    }
    fileDownload = false;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  Future<void> _downloadFgCapturedImage(
      List<Inspection> assignedInspevtion) async {
    for (var inspection in assignedInspevtion) {
      for (var inspectionDetails in inspection.fgInspectionDetails) {
        if (!fileDownload) {
          fileDownload = true;
          BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: true);
        }
        await inspectionDetails.downloadCapturedImages();
      }
    }
    fileDownload = false;
    BroadcastEvents().publish(Constants.SYNC_STARTED, arguments: false);
  }

  List<Inspection> getPendingSignatureInspection({String inspectionLotNo}) {
    List<Inspection> list = [];
    if (inspectionLotNo?.isEmpty ?? true) {
      assignedInspevtion?.forEach((element) {
        if (element.inspectionSignature == null &&
            element.status == Inspection.INSPECTION_STATUS_MODIFIED) {
          list.add(element);
        }
      });
    } else {
      list = assignedInspevtion
          .where((element) =>
      (inspectionLotNo.contains(element.inspectionLotNo) &&
          element.inspectionSignature == null &&
          element.status == Inspection.INSPECTION_STATUS_MODIFIED))
          .toList();
    }
    return list;
  }

  void goForSync() {
    EightFoldsRetrofit.isNetworkAvailable(showToast: false).then((value) {
      if (value) {
        uploadAllInspection();
      }
    });
  }
}
