import 'package:json_annotation/json_annotation.dart';
import 'pagination_model.dart';

part 'common_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CommonResponse<T> {
  final int? code;
  final int? status;
  final bool? success;
  @JsonKey(name: 'status_text')
  final String? statusText;
  final String? message;
  final T? data;
  final MetadataModel? metadata;

  CommonResponse({
    this.code,
    this.status,
    this.success,
    this.statusText,
    this.message,
    this.data,
    this.metadata,
  });

  factory CommonResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CommonResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$CommonResponseToJson(this, toJsonT);
}
