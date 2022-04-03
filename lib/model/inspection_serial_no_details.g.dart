// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_serial_no_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionSerialNoDetails _$InspectionSerialNoDetailsFromJson(
    Map<String, dynamic> json) {
  return InspectionSerialNoDetails(
    lotStartSrNo: json['lotStartSrNo'] as String,
    lotLastSrNo: json['lotLastSrNo'] as String,
    sampleSize: (json['sampleSize'] as num)?.toDouble(),
    sampleLotSrNo:
        (json['sampleLotSrNo'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$InspectionSerialNoDetailsToJson(
        InspectionSerialNoDetails instance) =>
    <String, dynamic>{
      'lotStartSrNo': instance.lotStartSrNo,
      'lotLastSrNo': instance.lotLastSrNo,
      'sampleSize': instance.sampleSize,
      'sampleLotSrNo': instance.sampleLotSrNo,
    };
