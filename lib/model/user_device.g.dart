// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) {
  return UserDevice(
    appPackage: json['appPackage'] as String,
    appVersionCode: json['appVersionCode'] as String,
    appVersionName: json['appVersionName'] as String,
    deviceId: json['deviceId'] as String,
    imei: json['imei'] as String,
    manufacturer: json['manufacturer'] as String,
    modelNumber: json['modelNumber'] as String,
    modifiedTime: json['modifiedTime'] as String,
    osVersion: json['osVersion'] as String,
    platform: json['platform'] as String,
    platformId: json['platformId'] as int,
    sdkBuildType: json['sdkBuildType'] as String,
    timeZone: json['timeZone'] as String,
    uid: json['uid'] as String,
    pushRegId: json['pushRegId'] as String,
  );
}

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) =>
    <String, dynamic>{
      'appPackage': instance.appPackage,
      'appVersionCode': instance.appVersionCode,
      'appVersionName': instance.appVersionName,
      'deviceId': instance.deviceId,
      'imei': instance.imei,
      'manufacturer': instance.manufacturer,
      'modelNumber': instance.modelNumber,
      'modifiedTime': instance.modifiedTime,
      'osVersion': instance.osVersion,
      'platform': instance.platform,
      'platformId': instance.platformId,
      'sdkBuildType': instance.sdkBuildType,
      'timeZone': instance.timeZone,
      'uid': instance.uid,
      'pushRegId': instance.pushRegId,
    };
