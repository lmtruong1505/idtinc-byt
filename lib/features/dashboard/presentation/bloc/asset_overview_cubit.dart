import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/asset_overview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AssetOverviewCubit extends Cubit<AssetOverviewState> {
  final AssetRepository _repository;

  AssetOverviewCubit(this._repository)
    : super(const AssetOverviewState(status: CubitStatus.init));

  Future<void> getAssetOverview({int? toChucId}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final actualToChucId = toChucId ?? 5; // Default to 5 ("Toàn viện")

    final response = await _repository.getAssetOverview(actualToChucId);

    if (response.success == true) {
      emit(state.copyWith(status: CubitStatus.success, data: response.data));
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
