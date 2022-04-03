import 'package:json_annotation/json_annotation.dart';

part 'app_file.g.dart';

@JsonSerializable()
class AppFile {
  String id;
  String fileId;
  int serviceId;
  String mimeType;
  String fileName;
  int fileStorageType;
  String filePath;
  int fileSize;
  String checksum;
  String width;
  String height;
  String createdBy;
  String createdTime;
  String modifiedTime;
  AppFile({
    this.id,
    this.fileId,
    this.serviceId,
    this.mimeType,
    this.fileName,
    this.fileStorageType,
    this.filePath,
    this.fileSize,
    this.checksum,
    this.width,
    this.height,
    this.createdBy,
    this.createdTime,
    this.modifiedTime,
  });

  factory AppFile.fromJson(Map<String, dynamic> json) {
    return _$AppFileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppFileToJson(this);
}
