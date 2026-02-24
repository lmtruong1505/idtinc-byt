import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class MetadataModel {
  final PaginationModel? pagination;

  MetadataModel({this.pagination});

  factory MetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MetadataModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  final int? count;
  @JsonKey(name: 'num_pages')
  final int? numPages;
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'previous_page')
  final int? previousPage;
  @JsonKey(name: 'next_page')
  final int? nextPage;
  @JsonKey(name: 'per_page')
  final int? perPage;

  PaginationModel({
    this.count,
    this.numPages,
    this.currentPage,
    this.previousPage,
    this.nextPage,
    this.perPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
