import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/models/department_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/department_catalog_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DepartmentCatalogCubit extends BaseCubit<DepartmentCatalogState> {
  final AssetRepository _repository;

  DepartmentCatalogCubit(this._repository)
    : super(const DepartmentCatalogState());

  Future<void> getMyDepartments({String toChucId = '5'}) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final response = await _repository.getDepartments(toChucId: toChucId);
    if (response.success == true) {
      emit(
        state.copyWith(
          status: CubitStatus.success,
          departments: response.data ?? [],
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          message: response.message ?? 'Đã có lỗi xảy ra',
        ),
      );
    }
  }

  void selectDepartment(DepartmentModel? department) {
    emit(state.copyWith(selectedDepartment: department));
  }
}
