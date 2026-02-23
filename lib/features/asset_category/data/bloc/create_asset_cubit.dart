import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_asset_state.dart';

class CreateAssetCubit extends Cubit<CreateAssetState> {
  CreateAssetCubit() : super(const CreateAssetState());

  // ── Tab ──────────────────────────────────────────────
  void switchTab(int index) {
    emit(state.copyWith(activeTab: index));
  }

  // ── Image ────────────────────────────────────────────
  void setImage(String path) {
    emit(state.copyWith(imagePath: path));
  }

  void removeImage() {
    emit(state.copyWith(imagePath: null));
  }

  // ── Text Fields ──────────────────────────────────────
  void updateAssetName(String value) {
    emit(state.copyWith(assetName: value));
  }

  void updateAssetCode(String value) {
    emit(state.copyWith(assetCode: value));
  }

  void updateAssetType(String? value) {
    emit(state.copyWith(assetType: value));
  }

  void updateUnit(String value) {
    emit(state.copyWith(unit: value));
  }

  void updateSerial(String value) {
    emit(state.copyWith(serial: value));
  }

  void updateModel(String value) {
    emit(state.copyWith(model: value));
  }

  void updateOrigin(String value) {
    emit(state.copyWith(origin: value));
  }

  void updateManufacturer(String value) {
    emit(state.copyWith(manufacturer: value));
  }

  void updateOriginalPrice(String value) {
    emit(state.copyWith(originalPrice: value));
  }

  void updateDepreciationDuration(String value) {
    emit(state.copyWith(depreciationDuration: value));
  }

  // ── Date Pickers ─────────────────────────────────────
  void updateManufacturingDate(String value) {
    emit(state.copyWith(manufacturingDate: value));
  }

  void updateUsageStartDate(String value) {
    emit(state.copyWith(usageStartDate: value));
  }

  // ── Depreciation ─────────────────────────────────────
  void setDepreciationMethod(DepreciationMethod method) {
    emit(state.copyWith(depreciationMethod: method));
  }

  void setDepreciationPeriod(DepreciationPeriod period) {
    emit(state.copyWith(depreciationPeriod: period));
  }

  // ── Submit ───────────────────────────────────────────
  /// Placeholder – sẽ gọi API khi ghép backend
  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true));

    // TODO: Gọi API tạo mới tài sản tại đây
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isSubmitting: false));
  }
}
