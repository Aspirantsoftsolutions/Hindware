// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionSignature _$InspectionSignatureFromJson(Map<String, dynamic> json) {
  return InspectionSignature(
    inspectorName: json['inspectorName'] as String,
    inspectorSignatureId: json['inspectorSignatureId'] as String,
    factoryRepresentativeName: json['factoryRepresentativeName'] as String,
    factoryRepresentativeSignatureId:
        json['factoryRepresentativeSignatureId'] as String,
  );
}

Map<String, dynamic> _$InspectionSignatureToJson(
        InspectionSignature instance) =>
    <String, dynamic>{
      'inspectorName': instance.inspectorName,
      'inspectorSignatureId': instance.inspectorSignatureId,
      'factoryRepresentativeName': instance.factoryRepresentativeName,
      'factoryRepresentativeSignatureId':
          instance.factoryRepresentativeSignatureId,
    };
