import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/depreciation_rate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DepreciationRateCubit extends Cubit<DepreciationRateState> {
  final AssetRepository _repository;

  DepreciationRateCubit(this._repository)
    : super(const DepreciationRateState(status: CubitStatus.init));

  Future<void> getDepreciationRate({int? toChucId, int? khoaId}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final actualToChucId = toChucId ?? 5; // Default to 5 ("Toàn viện")

    final response = await _repository.getAssetDepreciationRate(
      actualToChucId,
      khoaId: khoaId,
    );

    if (response.success == true) {
      emit(
        state.copyWith(status: CubitStatus.success, data: response.data ?? []),
      );
    } else {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          message: response.message ?? "Có lỗi xảy ra",
        ),
      );
    }
  }
}
