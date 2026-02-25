import 'package:bpg_retail/features/asset_category/data/models/asset_type_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'asset_form_delegate.dart';
import 'create_asset_state.dart';

class CreateAssetCubit extends Cubit<CreateAssetState>
    implements AssetFormDelegate {
  final AssetRepository _assetRepository = getIt.get<AssetRepository>();

  /// Danh sách tài sản có sẵn để chọn
  List<HospitalAssetModel> availableAssets = [];

  CreateAssetCubit() : super(const CreateAssetState());

  // ── Load available assets ──────────────────────────────
  Future<void> loadAvailableAssets() async {
    final response = await _assetRepository.getAssetList();
    if (response.success == true && response.data != null) {
      availableAssets = response.data!;
    }
  }

  // ── Tab ──────────────────────────────────────────────
  void switchTab(int index) {
    emit(state.copyWith(activeTab: index));
  }

  // ── Helper ──────────────────────────────────────────
  void _updateAssetDetail(
    AssetDetail Function(AssetDetail) updateFn, {
    int? attachedIndex,
  }) {
    if (attachedIndex == null) {
      emit(state.copyWith(mainAsset: updateFn(state.mainAsset)));
    } else {
      final newList = List<AttachedAsset>.from(state.attachedAssets);
      if (attachedIndex < newList.length) {
        newList[attachedIndex] = newList[attachedIndex].copyWith(
          assetDetail: updateFn(newList[attachedIndex].assetDetail),
        );
        emit(state.copyWith(attachedAssets: newList));
      }
    }
  }

  // ── Image ────────────────────────────────────────────
  void setImage(String path, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(imagePath: path),
      attachedIndex: attachedIndex,
    );
  }

  void removeImage({int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(imagePath: null),
      attachedIndex: attachedIndex,
    );
  }

  // ── Text Fields ──────────────────────────────────────
  void updateAssetName(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(assetName: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateAssetCode(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(assetCode: value),
      attachedIndex: attachedIndex,
    );
  }

  Future<void> loadAssetTypes() async {
    final response = await _assetRepository.getAssetTypes();
    if (response.success == true && response.data != null) {
      emit(state.copyWith(assetTypes: response.data!));
    }
  }

  void updateAssetType(AssetTypeModel? type, {int? attachedIndex}) {
    _updateAssetDetail((d) {
      String updatedDuration = d.depreciationDuration;
      if (type?.metaData?.thoiGianTinhKhauHao != null) {
        updatedDuration = type!.metaData!.thoiGianTinhKhauHao!.toString();
      }
      return d.copyWith(assetType: type, depreciationDuration: updatedDuration);
    }, attachedIndex: attachedIndex);
  }

  void updateUnit(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(unit: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateSerial(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(serial: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateModel(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(model: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateOrigin(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(origin: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateManufacturer(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(manufacturer: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateOriginalPrice(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(originalPrice: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateDepreciationDuration(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationDuration: value),
      attachedIndex: attachedIndex,
    );
  }

  // ── Date Pickers ─────────────────────────────────────
  void updateManufacturingDate(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(manufacturingDate: value),
      attachedIndex: attachedIndex,
    );
  }

  void updateUsageStartDate(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(usageStartDate: value),
      attachedIndex: attachedIndex,
    );
  }

  // ── Depreciation ─────────────────────────────────────
  void setDepreciationMethod(DepreciationMethod method, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationMethod: method),
      attachedIndex: attachedIndex,
    );
  }

  void setDepreciationPeriod(DepreciationPeriod period, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationPeriod: period),
      attachedIndex: attachedIndex,
    );
  }

  // ── Submit ───────────────────────────────────────────
  /// Placeholder – sẽ gọi API khi ghép backend
  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true));

    // TODO: Gọi API tạo mới tài sản tại đây
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isSubmitting: false));
  }

  // ── Attached Assets ──────────────────────────────────
  void addAttachedAsset() {
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.add(const AttachedAsset());
    emit(
      state.copyWith(
        attachedAssets: newList,
        currentAttachedAssetIndex: newList.length - 1,
      ),
    );
  }

  void removeAttachedAsset() {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.removeAt(state.currentAttachedAssetIndex);

    int newIndex = state.currentAttachedAssetIndex;
    if (newIndex >= newList.length && newList.isNotEmpty) {
      newIndex = newList.length - 1;
    } else if (newList.isEmpty) {
      newIndex = 0;
    }

    emit(
      state.copyWith(
        attachedAssets: newList,
        currentAttachedAssetIndex: newIndex,
      ),
    );
  }

  void nextAttachedAsset() {
    if (state.currentAttachedAssetIndex < state.attachedAssets.length - 1) {
      emit(
        state.copyWith(
          currentAttachedAssetIndex: state.currentAttachedAssetIndex + 1,
        ),
      );
    }
  }

  void previousAttachedAsset() {
    if (state.currentAttachedAssetIndex > 0) {
      emit(
        state.copyWith(
          currentAttachedAssetIndex: state.currentAttachedAssetIndex - 1,
        ),
      );
    }
  }

  void updateAttachedAssetAction(AttachedAssetAction action) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentAttachedAssetIndex] =
        newList[state.currentAttachedAssetIndex].copyWith(action: action);
    emit(state.copyWith(attachedAssets: newList));
  }

  void updateAttachedAssetId(String? id) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentAttachedAssetIndex] =
        newList[state.currentAttachedAssetIndex].copyWith(selectedAssetId: id);
    emit(state.copyWith(attachedAssets: newList));
  }
}
