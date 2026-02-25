import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:injectable/injectable.dart';

import 'asset_form_delegate.dart';
import 'add_accompanying_state.dart';
import 'create_asset_state.dart';

@injectable
class AddAccompanyingCubit extends BaseCubit<AddAccompanyingState>
    implements AssetFormDelegate {
  final AssetRepository _assetRepository;

  /// Danh sách tài sản có sẵn để chọn
  List<HospitalAssetModel> availableAssets = [];

  AddAccompanyingCubit(this._assetRepository)
    : super(const AddAccompanyingState());

  // ── Load available assets ──────────────────────────────
  Future<void> loadAvailableAssets() async {
    final response = await _assetRepository.getAssetList();
    if (response.success == true && response.data != null) {
      availableAssets = response.data!;
    }
  }

  // ── Attached Asset Management ──────────────────────────
  void addAttachedAsset() {
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.add(const AttachedAsset());
    emit(
      state.copyWith(attachedAssets: newList, currentIndex: newList.length - 1),
    );
  }

  void removeAttachedAsset() {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.removeAt(state.currentIndex);

    int newIndex = state.currentIndex;
    if (newIndex >= newList.length && newList.isNotEmpty) {
      newIndex = newList.length - 1;
    } else if (newList.isEmpty) {
      newIndex = 0;
    }

    emit(state.copyWith(attachedAssets: newList, currentIndex: newIndex));
  }

  void nextAsset() {
    if (state.currentIndex < state.attachedAssets.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void previousAsset() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  // ── Action Toggle ──────────────────────────────────────
  void updateAction(AttachedAssetAction action) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentIndex] = newList[state.currentIndex].copyWith(
      action: action,
    );
    emit(state.copyWith(attachedAssets: newList));
  }

  void updateSelectedAssetId(String? id) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentIndex] = newList[state.currentIndex].copyWith(
      selectedAssetId: id,
    );
    emit(state.copyWith(attachedAssets: newList));
  }

  // ── Create New: field updaters ─────────────────────────
  void _updateCurrentAssetDetail(AssetDetail Function(AssetDetail) updateFn) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    final idx = state.currentIndex;
    if (idx < newList.length) {
      newList[idx] = newList[idx].copyWith(
        assetDetail: updateFn(newList[idx].assetDetail),
      );
      emit(state.copyWith(attachedAssets: newList));
    }
  }

  @override
  void setImage(String path, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(imagePath: path));
  @override
  void removeImage({int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(imagePath: null));
  @override
  void updateAssetName(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(assetName: v));
  @override
  void updateAssetCode(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(assetCode: v));
  void updateAssetType(String? v) =>
      _updateCurrentAssetDetail((d) => d.copyWith(assetType: v));
  @override
  void updateUnit(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(unit: v));
  @override
  void updateSerial(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(serial: v));
  @override
  void updateModel(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(model: v));
  @override
  void updateOrigin(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(origin: v));
  @override
  void updateManufacturer(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(manufacturer: v));
  @override
  void updateOriginalPrice(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(originalPrice: v));
  @override
  void updateDepreciationDuration(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(depreciationDuration: v));
  @override
  void updateManufacturingDate(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(manufacturingDate: v));
  @override
  void updateUsageStartDate(String v, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(usageStartDate: v));
  @override
  void setDepreciationMethod(DepreciationMethod m, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(depreciationMethod: m));
  @override
  void setDepreciationPeriod(DepreciationPeriod p, {int? attachedIndex}) =>
      _updateCurrentAssetDetail((d) => d.copyWith(depreciationPeriod: p));

  // ── Submit ─────────────────────────────────────────────
  Future<bool> submit(int parentAssetId) async {
    if (state.attachedAssets.isEmpty) {
      navigator.showToast("Vui lòng thêm ít nhất một tài sản đi kèm");
      return false;
    }

    emit(state.copyWith(isSubmitting: true));

    // Process each attached asset
    for (final attached in state.attachedAssets) {
      if (attached.action == AttachedAssetAction.selectExisting) {
        if (attached.selectedAssetId == null) {
          navigator.showToast("Vui lòng chọn tài sản cho tất cả mục");
          emit(state.copyWith(isSubmitting: false));
          return false;
        }

        // Set parent for the selected asset
        final response = await _assetRepository.updateAsset(
          int.parse(attached.selectedAssetId!),
          {'parent': parentAssetId.toString(), 'to_chuc': '5'},
        );

        if (response.success != true) {
          navigator.showToast(
            response.message ?? "Thêm tài sản đi kèm thất bại",
          );
          emit(state.copyWith(isSubmitting: false));
          return false;
        }
      } else {
        // TODO: Gọi API tạo mới tài sản + gán parent
      }
    }

    emit(state.copyWith(isSubmitting: false));
    navigator.showToast("Thêm tài sản đi kèm thành công");
    return true;
  }
}
