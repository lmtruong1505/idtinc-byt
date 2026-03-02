import 'package:tasa/features/authentication/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  final UserModel? user;

  AuthResponse({this.refreshToken, this.accessToken, this.deviceId, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
