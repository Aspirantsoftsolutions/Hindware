import 'package:json_annotation/json_annotation.dart';
part 'inspection_serial_no_details.g.dart';

@JsonSerializable()
class InspectionSerialNoDetails {
  String lotStartSrNo;
  String lotLastSrNo;
  double sampleSize;
  List<String> sampleLotSrNo;

  InspectionSerialNoDetails({
    this.lotStartSrNo,
    this.lotLastSrNo,
    this.sampleSize,
    this.sampleLotSrNo,
  });

  factory InspectionSerialNoDetails.fromJson(Map<String, dynamic> json) =>
      _$InspectionSerialNoDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionSerialNoDetailsToJson(this);
}
