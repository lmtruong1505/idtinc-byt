import 'package:json_annotation/json_annotation.dart';
import 'pagination_model.dart';

part 'common_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CommonListResponse<T> {
  final int? code;
  final int? status;
  final bool? success;
  @JsonKey(name: 'status_text')
  final String? statusText;
  final String? message;
  final List<T>? data;
  final MetadataModel? metadata;

  CommonListResponse({
    this.code,
    this.status,
    this.success,
    this.statusText,
    this.message,
    this.data,
    this.metadata,
  });

  factory CommonListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CommonListResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$CommonListResponseToJson(this, toJsonT);
}
