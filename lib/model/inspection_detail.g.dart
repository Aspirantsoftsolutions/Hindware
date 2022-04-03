// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionDetail _$InspectionDetailFromJson(Map<String, dynamic> json) {
  return InspectionDetail(
    characNo: json['characNo'] as String,
    mastCharac: json['mastCharac'] as String,
    shortDesc: json['shortDesc'] as String,
    referenceImage: json['referenceImage'] as String,
    localReferenceImage: json['localReferenceImage'] as String,
    frequency: json['frequency'] as String,
    type: json['type'] as String,
    specification: json['specification'] as String,
    result: json['result'] as String,
    decision: json['decision'] as int,
    noOfMeasurements: json['noOfMeasurements'] as int,
    remarks: json['remarks'] as String,
    capturedImages:
        (json['capturedImages'] as List)?.map((e) => e as String)?.toList(),
    quantitativeResult:
        (json['quantitativeResult'] as List)?.map((e) => e as String)?.toList(),
    minSpec: (json['minSpec'] as num)?.toDouble(),
    maxSpec: (json['maxSpec'] as num)?.toDouble(),
    groupNum: json['groupNum'] as String,
    samplingFreqType: json['samplingFreqType'] as bool,
    uniqueNumber: json['uniqueNumber'] as String,
    alphaNumericResult: json['alphaNumericResult'] as bool,
  );
}

Map<String, dynamic> _$InspectionDetailToJson(InspectionDetail instance) =>
    <String, dynamic>{
      'characNo': instance.characNo,
      'mastCharac': instance.mastCharac,
      'shortDesc': instance.shortDesc,
      'referenceImage': instance.referenceImage,
      'localReferenceImage': instance.localReferenceImage,
      'frequency': instance.frequency,
      'type': instance.type,
      'specification': instance.specification,
      'result': instance.result,
      'decision': instance.decision,
      'noOfMeasurements': instance.noOfMeasurements,
      'remarks': instance.remarks,
      'capturedImages': instance.capturedImages,
      'quantitativeResult': instance.quantitativeResult,
      'minSpec': instance.minSpec,
      'maxSpec': instance.maxSpec,
      'groupNum': instance.groupNum,
      'uniqueNumber': instance.uniqueNumber,
      'samplingFreqType': instance.samplingFreqType,
      'alphaNumericResult': instance.alphaNumericResult,
    };
