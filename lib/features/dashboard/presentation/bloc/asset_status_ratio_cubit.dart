import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/features/asset_category/data/repositories/asset_repository.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_status_ratio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AssetStatusRatioCubit extends Cubit<AssetStatusRatioState> {
  final AssetRepository _repository;

  AssetStatusRatioCubit(this._repository)
    : super(const AssetStatusRatioState());

  Future<void> getAssetStatusRatio({int? toChucId, int? khoaId}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final actualToChucId = toChucId ?? 5;

    final response = await _repository.getAssetStatusRatio(
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
          message: response.message ?? 'Đã có lỗi xảy ra',
        ),
      );
    }
  }
}
