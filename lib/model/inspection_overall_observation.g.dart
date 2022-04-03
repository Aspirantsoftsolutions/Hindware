// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_overall_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionOverallObservation _$InspectionOverallObservationFromJson(
    Map<String, dynamic> json) {
  return InspectionOverallObservation(
    observations: json['observations'] as String,
    actionTaken: json['actionTaken'] as String,
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$InspectionOverallObservationToJson(
        InspectionOverallObservation instance) =>
    <String, dynamic>{
      'observations': instance.observations,
      'actionTaken': instance.actionTaken,
      'status': instance.status,
    };
