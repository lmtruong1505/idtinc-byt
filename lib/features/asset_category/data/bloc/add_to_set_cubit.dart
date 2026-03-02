import 'package:tasa/core/base/base_cubit.dart';
import 'package:tasa/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:tasa/features/asset_category/data/models/asset_type_model.dart';
import 'package:tasa/features/asset_category/data/repositories/asset_repository.dart';
import 'package:injectable/injectable.dart';

import 'asset_form_delegate.dart';
import 'add_to_set_state.dart';
import 'create_asset_state.dart';

@injectable
class AddToSetCubit extends BaseCubit<AddToSetState>
    implements AssetFormDelegate {
  final AssetRepository _assetRepository;

  /// Danh sách tài sản có sẵn để chọn làm tài sản chính
  List<HospitalAssetModel> availableAssets = [];

  AddToSetCubit(this._assetRepository) : super(const AddToSetState());

  // ── Action Toggle ──────────────────────────────────────
  void switchAction(AddToSetAction action) {
    emit(state.copyWith(action: action));
  }

  // ── Select Existing ────────────────────────────────────
  void selectParent(int? id) {
    emit(state.copyWith(selectedParentId: id));
  }

  // ── Load available assets ──────────────────────────────
  Future<void> loadAvailableAssets(int currentAssetId) async {
    final response = await _assetRepository.getAssetList(
      timTaiSanChinhId: currentAssetId,
    );
    if (response.success == true && response.data != null) {
      availableAssets = response.data!;
    }
  }

  Future<void> loadAssetTypes() async {
    final response = await _assetRepository.getAssetTypes();
    if (response.success == true && response.data != null) {
      emit(state.copyWith(assetTypes: response.data!));
    }
  }

  // ── Create New: field updaters ─────────────────────────
  void _updateNewParent(AssetDetail Function(AssetDetail) updateFn) {
    emit(state.copyWith(newParentAsset: updateFn(state.newParentAsset)));
  }

  @override
  void setImage(String path, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(imagePath: path));
  @override
  void removeImage({int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(imagePath: null));
  @override
  void updateAssetName(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(assetName: v));
  @override
  void updateAssetCode(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(assetCode: v));
  @override
  void updateAssetType(AssetTypeModel? type, {int? attachedIndex}) {
    _updateNewParent((d) {
      String updatedDuration = d.depreciationDuration;
      if (type?.metaData?.thoiGianTinhKhauHao != null) {
        updatedDuration = type!.metaData!.thoiGianTinhKhauHao!.toString();
      }
      return d.copyWith(assetType: type, depreciationDuration: updatedDuration);
    });
  }

  @override
  void updateUnit(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(unit: v));
  @override
  void updateSerial(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(serial: v));
  @override
  void updateModel(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(model: v));
  @override
  void updateOrigin(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(origin: v));
  @override
  void updateManufacturer(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(manufacturer: v));
  @override
  void updateOriginalPrice(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(originalPrice: v));
  @override
  void updateDepreciationDuration(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(depreciationDuration: v));
  @override
  void updateManufacturingDate(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(manufacturingDate: v));
  @override
  void updateUsageStartDate(String v, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(usageStartDate: v));
  @override
  void setDepreciationMethod(DepreciationMethod m, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(depreciationMethod: m));
  @override
  void setDepreciationPeriod(DepreciationPeriod p, {int? attachedIndex}) =>
      _updateNewParent((d) => d.copyWith(depreciationPeriod: p));

  // ── Submit ─────────────────────────────────────────────
  Future<bool> submit(int currentAssetId) async {
    emit(state.copyWith(isSubmitting: true));

    if (state.action == AddToSetAction.selectExisting) {
      if (state.selectedParentId == null) {
        navigator.showToast("Vui lòng chọn tài sản chính");
        emit(state.copyWith(isSubmitting: false));
        return false;
      }

      final response = await _assetRepository.updateAsset(currentAssetId, {
        'parent': state.selectedParentId.toString(),
        'to_chuc': '5',
      });

      emit(state.copyWith(isSubmitting: false));

      if (response.success == true) {
        navigator.showToast(
          response.message ?? "Thêm vào bộ tài sản thành công",
        );
        return true;
      } else {
        navigator.showToast(response.message ?? "Thêm vào bộ tài sản thất bại");
        return false;
      }
    } else {
      // TODO: Gọi API tạo mới tài sản chính + gán parent
      emit(state.copyWith(isSubmitting: false));
      navigator.showToast("Đã lưu tài sản chính");
      return true;
    }
  }
}
