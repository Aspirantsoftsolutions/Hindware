// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inspection _$InspectionFromJson(Map<String, dynamic> json) {
  return Inspection(
    inspectionLotNo: json['inspectionLotNo'] as String,
    dateCreated: json['dateCreated'] == null
        ? null
        : MyInstant.fromJson(json['dateCreated'] as Map<String, dynamic>),
    clientUserId: json['clientUserId'] as String,
    materialNo: json['materialNo'] as String,
    materialDesc: json['materialDesc'] as String,
    materialModel: json['materialModel'] as String,
    materialModelName: json['materialModelName'] as String,
    plant: json['plant'] as String,
    poQuality: json['poQuality'] as int,
    noOfItemsInBOM: (json['noOfItemsInBOM'] as num)?.toDouble(),
    noOfItemsInFG: (json['noOfItemsInFG'] as num)?.toDouble(),
    bomTitle: json['bomTitle'] as String,
    fgTitle: json['fgTitle'] as String,
    poNumber: json['poNumber'] as String,
    version: json['version'] as String,
    // versions: (json['versions'] as List)
    //     ?.map((e) => e == null
    //         ? null
    //         : Inspection.fromJson(e as Map<String, dynamic>))
    //     ?.toList(),
    bomInspectionDetails: (json['bomInspectionDetails'] as List)
        ?.map((e) => e == null
        ? null
        : InspectionDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    fgInspectionDetails: (json['fgInspectionDetails'] as List)
        ?.map((e) => e == null
            ? null
            : InspectionDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    fgFinished: json['fgFinished'] as bool,
    baseLot: json['baseLot'] as bool,
    bomFinished: json['bomFinished'] as bool,
    inspectedQuality: (json['inspectedQuality'] as num)?.toDouble(),
    vqty: (json['vqty'] as num)?.toDouble(),
    toBeInspected: (json['toBeInspected'] as num)?.toDouble(),
    decision: json['decision'] as int,
    remarks: json['remarks'] as String,
    inspectionStartTime: json['inspectionStartTime'] == null
        ? null
        : MyInstant.fromJson(
            json['inspectionStartTime'] as Map<String, dynamic>),
    inspectionEndTime: json['inspectionEndTime'] == null
        ? null
        : MyInstant.fromJson(json['inspectionEndTime'] as Map<String, dynamic>),
    status: json['status'] as String,
    createdTime: json['createdTime'] == null
        ? null
        : MyInstant.fromJson(json['createdTime'] as Map<String, dynamic>),
    modifiedTime: json['modifiedTime'] == null
        ? null
        : MyInstant.fromJson(json['modifiedTime'] as Map<String, dynamic>),
    deleted: json['deleted'] as bool,
    assignedToUserId: json['assignedToUserId'] as String,
    overallObservations: (json['overallObservations'] as List)
        ?.map((e) => e == null
            ? null
            : InspectionOverallObservation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    inspectionGroupDetails: (json['inspectionGroupDetails'] as List)
        ?.map((e) => e == null
            ? null
            : InspectionGroupDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    vendorMailId: json['vendorMailId'] as String,
  )
    ..inspectionSignature = json['inspectionSignature'] == null
        ? null
        : InspectionSignature.fromJson(
            json['inspectionSignature'] as Map<String, dynamic>)
    ..inspectionSerialNoDetails = json['inspectionSerialNoDetails'] == null
        ? null
        : InspectionSerialNoDetails.fromJson(
            json['inspectionSerialNoDetails'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InspectionToJson(Inspection instance) =>
    <String, dynamic>{
      'inspectionLotNo': instance.inspectionLotNo,
      'dateCreated': instance.dateCreated,
      'clientUserId': instance.clientUserId,
      'materialNo': instance.materialNo,
      'materialDesc': instance.materialDesc,
      'materialModel': instance.materialModel,
      'materialModelName': instance.materialModelName,
      'plant': instance.plant,
      'poQuality': instance.poQuality,
      'noOfItemsInBOM': instance.noOfItemsInBOM,
      'noOfItemsInFG': instance.noOfItemsInFG,
      'bomTitle': instance.bomTitle,
      'fgTitle': instance.fgTitle,
      'poNumber': instance.poNumber,
      'version': instance.version,
      'bomInspectionDetails': instance.bomInspectionDetails,
      // 'versions':instance.versions,
      'fgInspectionDetails': instance.fgInspectionDetails,
      'fgFinished': instance.fgFinished,
      'baseLot': instance.baseLot,
      'bomFinished': instance.bomFinished,
      'inspectedQuality': instance.inspectedQuality,
      'vqty': instance.vqty,
      'toBeInspected': instance.toBeInspected,
      'decision': instance.decision,
      'remarks': instance.remarks,
      'inspectionStartTime': instance.inspectionStartTime,
      'inspectionEndTime': instance.inspectionEndTime,
      'status': instance.status,
      'createdTime': instance.createdTime,
      'modifiedTime': instance.modifiedTime,
      'deleted': instance.deleted,
      'assignedToUserId': instance.assignedToUserId,
      'inspectionSignature': instance.inspectionSignature,
      'overallObservations': instance.overallObservations,
      'inspectionSerialNoDetails': instance.inspectionSerialNoDetails,
      'inspectionGroupDetails': instance.inspectionGroupDetails,
      'vendorMailId': instance.vendorMailId,
    };
