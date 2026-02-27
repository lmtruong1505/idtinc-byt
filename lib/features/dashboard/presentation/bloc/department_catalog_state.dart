import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/models/department_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_catalog_state.freezed.dart';

@freezed
class DepartmentCatalogState with _$DepartmentCatalogState {
  const factory DepartmentCatalogState({
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
    @Default([]) List<DepartmentModel> departments,
    DepartmentModel? selectedDepartment,
  }) = _DepartmentCatalogState;
}
