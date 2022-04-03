import 'package:json_annotation/json_annotation.dart';

part 'user_device.g.dart';

@JsonSerializable()
class UserDevice {
  String appPackage;
  String appVersionCode;
  String appVersionName;
  String deviceId;
  String imei;
  String manufacturer;
  String modelNumber;
  String modifiedTime;
  String osVersion;
  String platform;
  int platformId;
  String sdkBuildType;
  String timeZone;
  String uid;
  String pushRegId;
  UserDevice({
    this.appPackage,
    this.appVersionCode,
    this.appVersionName,
    this.deviceId,
    this.imei,
    this.manufacturer,
    this.modelNumber,
    this.modifiedTime,
    this.osVersion,
    this.platform,
    this.platformId,
    this.sdkBuildType,
    this.timeZone,
    this.uid,
    this.pushRegId,
  });

  UserDevice.empty();
  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);
}
