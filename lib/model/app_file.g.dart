// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppFile _$AppFileFromJson(Map<String, dynamic> json) {
  return AppFile(
    id: json['id'] as String,
    fileId: json['fileId'] as String,
    serviceId: json['serviceId'] as int,
    mimeType: json['mimeType'] as String,
    fileName: json['fileName'] as String,
    fileStorageType: json['fileStorageType'] as int,
    filePath: json['filePath'] as String,
    fileSize: json['fileSize'] as int,
    checksum: json['checksum'] as String,
    width: json['width'] as String,
    height: json['height'] as String,
    createdBy: json['createdBy'] as String,
    createdTime: json['createdTime'] as String,
    modifiedTime: json['modifiedTime'] as String,
  );
}

Map<String, dynamic> _$AppFileToJson(AppFile instance) => <String, dynamic>{
      'id': instance.id,
      'fileId': instance.fileId,
      'serviceId': instance.serviceId,
      'mimeType': instance.mimeType,
      'fileName': instance.fileName,
      'fileStorageType': instance.fileStorageType,
      'filePath': instance.filePath,
      'fileSize': instance.fileSize,
      'checksum': instance.checksum,
      'width': instance.width,
      'height': instance.height,
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'modifiedTime': instance.modifiedTime,
    };
