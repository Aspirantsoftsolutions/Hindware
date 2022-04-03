// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_instant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyInstant _$MyInstantFromJson(Map<String, dynamic> json) {
  return MyInstant(
    epochSecond: json['epochSecond'] as int,
    nano: json['nano'] as int,
  );
}

Map<String, dynamic> _$MyInstantToJson(MyInstant instance) => <String, dynamic>{
      'epochSecond': instance.epochSecond,
      'nano': instance.nano,
    };
