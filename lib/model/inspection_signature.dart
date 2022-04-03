
import 'package:json_annotation/json_annotation.dart';

part 'inspection_signature.g.dart';
@JsonSerializable()
class InspectionSignature {
  String inspectorName;
  String inspectorSignatureId;

  String factoryRepresentativeName;
  String factoryRepresentativeSignatureId;

  InspectionSignature(
      {this.inspectorName,
      this.inspectorSignatureId,
      this.factoryRepresentativeName,
      this.factoryRepresentativeSignatureId});


  factory InspectionSignature.fromJson(Map<String, dynamic> json) {
    return _$InspectionSignatureFromJson(json);
  }

  Map<String, dynamic> toJson() => _$InspectionSignatureToJson(this);
}
