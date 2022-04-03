import 'package:json_annotation/json_annotation.dart';

part 'inspection_overall_observation.g.dart';

@JsonSerializable()
class InspectionOverallObservation {
  String observations;
  String actionTaken;
  String status;
  InspectionOverallObservation({
    this.observations,
    this.actionTaken,
    this.status,
  });

  factory InspectionOverallObservation.fromJson(Map<String, dynamic> json) =>
      _$InspectionOverallObservationFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionOverallObservationToJson(this);
}
