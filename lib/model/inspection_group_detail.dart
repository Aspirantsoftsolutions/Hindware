import 'package:json_annotation/json_annotation.dart';

import 'package:SomanyHIL/model/inspection_detail.dart';

part 'inspection_group_detail.g.dart';

@JsonSerializable()
class InspectionGroupDetail {
  String uniqueCode;
  String title;
  List<InspectionDetail> fgItems;
  String mastCharac;
  String type;
  String summary;
  String finalObservation;
  int acceptedCount;
  int notAcceptedCount;
  int notCapturedCount;

  String countString;
  InspectionGroupDetail({
    this.uniqueCode,
    this.title,
    this.fgItems,
    this.mastCharac,
    this.type,
    this.summary,
    this.finalObservation,
    this.acceptedCount,
    this.notAcceptedCount,
    this.notCapturedCount,
    this.countString,
  });

  factory InspectionGroupDetail.fromJson(Map<String, dynamic> json) {
    return _$InspectionGroupDetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$InspectionGroupDetailToJson(this);
}
