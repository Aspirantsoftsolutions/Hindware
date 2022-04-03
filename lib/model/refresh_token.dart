import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable()
class RefreshToken {
  String token;
  RefreshToken({
    this.token,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return _$RefreshTokenFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);
}
