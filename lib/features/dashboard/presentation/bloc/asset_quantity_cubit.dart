import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/asset_quantity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AssetQuantityCubit extends Cubit<AssetQuantityState> {
  final AssetRepository _repository;

  AssetQuantityCubit(this._repository) : super(const AssetQuantityState());

  Future<void> getAssetQuantityReport({int? toChucId, int? khoaId}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final actualToChucId = toChucId ?? 5;

    final response = await _repository.getAssetQuantityReport(
      actualToChucId,
      khoaId: khoaId,
    );

    if (response.success == true) {
      emit(state.copyWith(status: CubitStatus.success, data: response.data));
    } else {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          message: response.message ?? 'Đã có lỗi xảy ra',
        ),
      );
    }
  }
}
