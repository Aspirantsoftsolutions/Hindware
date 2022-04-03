// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_group_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionGroupDetail _$InspectionGroupDetailFromJson(
    Map<String, dynamic> json) {
  return InspectionGroupDetail(
    uniqueCode: json['uniqueCode'] as String,
    title: json['title'] as String,
    fgItems: (json['fgItems'] as List)
        ?.map((e) => e == null
            ? null
            : InspectionDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    mastCharac: json['mastCharac'] as String,
    type: json['type'] as String,
    summary: json['summary'] as String,
    finalObservation: json['finalObservation'] as String,
    acceptedCount: json['acceptedCount'] as int,
    notAcceptedCount: json['notAcceptedCount'] as int,
    notCapturedCount: json['notCapturedCount'] as int,
    countString: json['countString'] as String,
  );
}

Map<String, dynamic> _$InspectionGroupDetailToJson(
        InspectionGroupDetail instance) =>
    <String, dynamic>{
      'uniqueCode': instance.uniqueCode,
      'title': instance.title,
      'fgItems': instance.fgItems,
      'mastCharac': instance.mastCharac,
      'type': instance.type,
      'summary': instance.summary,
      'finalObservation': instance.finalObservation,
      'acceptedCount': instance.acceptedCount,
      'notAcceptedCount': instance.notAcceptedCount,
      'notCapturedCount': instance.notCapturedCount,
      'countString': instance.countString,
    };
